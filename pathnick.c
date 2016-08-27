// ================================================================
// PATHNICK.C
//
// I use this to bling out my shell prompt a bit, letting it show me if I'm
// currently cd'ed anywhere inside a particular project directory.
//
// SETUP:
//
// * gcc pathnick.c -o pathnick and put pathnick somewhere in my $PATH
//
// * In my shell rc file, things like
//
//   export PATHNICKS="$HOME/project:PROJECT1"
//   export PATHNICKS="$PATHNICKS,$HOME/project2:PROJECT2"
//   export PATHNICKS="$PATHNICKS,$HOME:HOME"
//   export PATHNICKS="$PATHNICKS,/tmp:TMP"
//
// * Then for my $PS1 I can do things like
//
//   export PS1='\u@\h`pathnick`[\W]\$ '
//
//   (Note that for Bash PS1, \u is username, \h is hostname, and \W is final
//   component of the pwd.)
//
// RESULT:
//
// The resulting prompts are things like
//
//   myname@myhost[PROJECT1][src]$
//
// NOTES:
//
// * I get the '[PROJECT1]' part in my prompt if I'm cd'ed into
//   $HOME/project, or any of its child directories.
//
// * I put more-specific paths higher up in the $PATHNICKS environment
//   variable, e.g. if I'm in $HOME/project2/java/src then I'll have
//   [PROJECT2] in my prompt, but if I'm in $HOME/something/else then
//   I'll have [HOME] in my prompt. And if I'm in /usr then I'll have
//   none of the above. (Note that a '/' rule will result in pathnick
//   always printing something.)
//
// ================================================================
// John Kerl // github.com/johnkerl // 2016-08-24
// ================================================================

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define DEFAULT_ENV_NAME   "PATHNICKS"
#define PATH_SIZE          1024
#define INITIAL_ARRAY_SIZE 1
#define TRUE               1
#define FALSE              0

typedef struct _opts_t {
	char* argv0;
	int verbose;
	char* env_name;
	char* specified_pwd;
} opts_t;

typedef struct _name_t {
	char* prefix;
	char* nickname;
} name_t;

static void set_defaults(opts_t* popts);
static int parse_command_line(opts_t* popts, int* pexit_rc, int argc, char** argv);
static name_t* load_path_nicks(opts_t* popts);

// ----------------------------------------------------------------
static void usage(char* argv0, FILE* fp) {
	fprintf(fp, "Usage: %s [options]\n", argv0);
	fprintf(fp,
		"Options:\n"
		"-v:  verbose mode.\n"
		"-e {env name}: name of environment variable in which to look up path nicknames.\n"
		"  If omitted, defaults to " DEFAULT_ENV_NAME ".\n"
		"-d {dir name}: path to look up. If omitted, defaults to the pwd.\n"
		"Example environment variable: \"/home/myname:HOME,/tmp:TMP\".\n"
		"Given the specified directory, loops through the path=nick pairs in the\n"
		"environment variable. If the specified directory is, or is a subdirectory of, one of the paths,\n"
		"prints the corresponding nickname. Otherwise, prints nothing.\n");
}

int main(int argc, char** argv) {
	opts_t opts;
	opts_t* popts = &opts;
	int exit_rc = 0;

	set_defaults(popts);
	if (!parse_command_line(popts, &exit_rc, argc, argv)) {
		FILE* fp = (exit_rc == 0) ? stdout : stderr;
		usage(argv[0], fp);
		exit(exit_rc);
	}

	name_t* names = load_path_nicks(popts);
	if (names == NULL)
		return 1;

	char pwd_buffer[PATH_SIZE];
	char* pwd = (popts->specified_pwd != NULL) ? popts->specified_pwd : getcwd(pwd_buffer, PATH_SIZE);

	for (int i = 0; names[i].prefix != NULL; i++) {
		char* prefix = names[i].prefix;
		char* slashy_prefix = malloc(strlen(prefix) + 2);
		strcpy(slashy_prefix, prefix);
		strcat(slashy_prefix, "/");
		if (popts->verbose) {
			printf("\n");
			printf("%s: slashy_prefix: %s\n", popts->argv0, slashy_prefix);
			printf("%s: prefix:        %s\n", popts->argv0, prefix);
			printf("%s: dir            %s\n", popts->argv0, pwd);
		}
		if (
			strncmp(pwd, slashy_prefix, strlen(slashy_prefix)) == 0
			||
			strcmp(pwd, prefix) == 0
		)
		{
			printf("[%s]\n", names[i].nickname);
			break;
		}
	}

	free(names);

	return 0;
}

// ----------------------------------------------------------------
static void set_defaults(opts_t* popts) {
	popts->verbose       = FALSE;
	popts->env_name      = DEFAULT_ENV_NAME;
	popts->specified_pwd = NULL;
}

// ----------------------------------------------------------------
static int parse_command_line(opts_t* popts, int* pexit_rc, int argc, char** argv) {
	popts->argv0 = argv[0];
	*pexit_rc = 1;

	int argi = 1;
	while (argi < argc && argv[argi][0] == '-') {
		if (!strcmp(argv[argi], "-h") || !strcmp(argv[argi], "--help")) {
			usage(argv[0], stdout);
			*pexit_rc = 0;
			return FALSE;

		} else if (!strcmp(argv[argi], "-v")) {
			popts->verbose = TRUE;
			argi++;

		} else if (!strcmp(argv[argi], "-e")) {
			if ((argc - argi) < 2) {
				return FALSE;
			}
			popts->env_name = argv[argi+1];
			argi += 2;

		} else if (!strcmp(argv[argi], "-d")) {
			if ((argc - argi) < 2) {
				return FALSE;
			}
			popts->specified_pwd = argv[argi+1];
			argi += 2;

		} else {
			fprintf(stderr, "%s: unrecognized option \"%s\".\n", argv[0], argv[argi]);
			return FALSE;
		}
	}

	if (argi != argc) {
		fprintf(stderr, "%s: extraneous argument \"%s\".\n", argv[0], argv[argi]);
		*pexit_rc = 1;
		return FALSE;
	}
	*pexit_rc = 0;

	return TRUE;
}

// ----------------------------------------------------------------
// Returns an array terminated by null prefix & name.
static name_t* load_path_nicks(opts_t* popts) {
	int num_allocated = INITIAL_ARRAY_SIZE;
	int num_names = 0;
	char* delimiter = ",";
	char* pairer = ":";
	int pairer_length = strlen(pairer);

	if (popts->verbose) {
		printf("%s: env_name=[%s]\n", popts->argv0, popts->env_name);
	}

	char* env_value = getenv(popts->env_name);
	if (env_value == NULL) {
		if (popts->verbose) {
			printf("%s: env_value=null\n", popts->argv0);
		}
		return NULL;
	}
	env_value = strdup(env_value);
	if (popts->verbose) {
		printf("%s: env_value=[%s]\n", popts->argv0, env_value);
	}

	name_t* names = (name_t*) malloc(num_allocated * sizeof(name_t));
	char* p = env_value;
	char* pair = NULL;
	while ((pair = strsep(&p, delimiter)) != NULL) {
		char* ppairer = strstr(pair, pairer);
		if (ppairer == NULL) {
			if (popts->verbose) {
				printf("%s: [%s] => no pairer \"%s\"\n", popts->argv0, pair, pairer);
			}
			continue;
		}
		*ppairer = 0;
		char* path = pair;
		char* nick = ppairer + pairer_length;

		if (popts->verbose) {
			printf("%s: [%s] => [%s]=[%s]\n", popts->argv0, pair, path, nick);
		}

		if (num_names >= num_allocated) {
			num_allocated *= 2;
			names = realloc(names, num_allocated * sizeof(name_t));
		}
		names[num_names].prefix = strdup(path);
		names[num_names].nickname = strdup(nick);
		num_names++;

		// Null-terminate the array.
		if (num_names >= num_allocated) {
			num_allocated *= 2;
			names = realloc(names, num_allocated * sizeof(name_t));
			names[num_names].prefix = NULL;
			names[num_names].nickname = NULL;
		}
	}

	free(env_value);
	return names;
}
