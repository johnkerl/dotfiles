.First <- function() {
  # print("You changed your R options")
  # options(error = traceback)
  options("menu.graphics" = FALSE) # no Xquartz pop-ups when I'm using the CLI

  # options(repos = list(CRAN = "https://cran.rstudio.com"))
  # options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/2023-10-09"))
  options(repos = c(CRAN = "https://cran.r-project.org"))

  if (interactive()) {
    library(tiledb)
    #library(tiledbcloud)
    library(tiledbsoma)
    library(tinytest)
    #library(future)
    namespace <<- 'johnkerl-tiledb'
    namespaceToCharge <<- namespace
    cat("R:            ", R.Version()$version.string,                     "\n")
    cat("tiledb:       ", toString(utils::packageVersion("tiledb")),      "\n")
    cat("core:         ", as.character(tiledb::tiledb_version(compact=TRUE)), "\n")
    #cat("tiledbcloud: ", toString(utils::packageVersion("tiledbcloud")), "\n")
    #cat("tiledbsoma:   ", toString(utils::packageVersion("tiledbsoma")),    "\n")
    tiledbsoma::show_package_versions()
    #cat("tinytest:     ", toString(utils::packageVersion("tinytest")),    "\n")
    #cat("future:       ", toString(utils::packageVersion("future")),      "\n")
    #cat("namespace:    ", namespace, "\n")
  }
  # Not the workspace, just my previous CLI commands
  if(interactive()) try(utils::loadhistory("~/.Rhistory"))
}

.Last <- function() {
  # Not the workspace, just my previous CLI commands
  if(interactive()) try(utils::savehistory("~/.Rhistory"))
}

vers <- function() {
  print(packageVersion("tiledb"))
  print(packageVersion("tiledbcloud"))
}

#t    <- function() { library(tiledb)        }
#tc   <- function() { library(tiledbcloud)   }
#d    <- function() { library(devtools)      }
dla  <- function() { devtools::load_all()   }
rox  <- function() { roxygen2::roxygenise() }
ddoc <- function() { devtools::document()   }
pbs  <- function() { pkgdown::build_site()  }

tnt  <- function() { tinytest::run_test_dir('inst/tinytest') }
tht  <- function() { testthat::test_local("tests/testthat") }
tsmx <- function() { testthat::set_max_fails(Inf) }

dlatht <- function() { devtools::load_all(); testthat::test_local("tests/testthat") }

tfac  <- function() { testthat::test_file("tests/testthat/test-Factory.R") }
#tsdf  <- function() { testthat::test_file("tests/testthat/test-SOMADataFrame.R") }
tsdf  <- function() { devtools::test_active_file(file="tests/testthat/test-SOMADataFrame.R") }
tsnda <- function() { devtools::test_active_file(file="tests/testthat/test-SOMASparseNDArray.R") }
tsh   <- function() { devtools::test_active_file(file="tests/testthat/test-shape.R") }
tseq  <- function() { testthat::test_file("tests/testthat/test-SOMAExperiment-query.R") }
tsceo <- function() { testthat::test_file("tests/testthat/test-SCEOutgest.R") }

tht1  <- function(filename) { devtools::test_active_file(file=filename) }

tta   <- function() { tinytest::test_all(".")                                           }
tcurg <- function() { tinytest::run_test_file("inst/tinytest/test_c_udf_reg_generic.R") }
tcue  <- function() { tinytest::run_test_file("inst/tinytest/test_c_udf_execution.R")   }
ttd1  <- function() { tinytest::run_test_file("inst/tinytest/test_a_delayed_1.R")       }
ttd2  <- function() { tinytest::run_test_file("inst/tinytest/test_a_delayed_2.R")       }
ttd3  <- function() { tinytest::run_test_file("inst/tinytest/test_a_delayed_3.R")       }
ttd4  <- function() { tinytest::run_test_file("inst/tinytest/test_a_delayed_4.R")       }
ttd5  <- function() { tinytest::run_test_file("inst/tinytest/test_d_delayed_5.R")       }
ttd6  <- function() { tinytest::run_test_file("inst/tinytest/test_d_delayed_6.R")       }
ttd7  <- function() { tinytest::run_test_file("inst/tinytest/test_d_delayed_7.R")       }
ttdr  <- function() { tinytest::test_package("tiledb")                                  }
ttdc  <- function() { tinytest::test_package("tiledbcloud")                             }

tdon  <- function() { Sys.setenv(TILEDB_CLOUD_R_HTTP_DEBUG='true') }
tdoff <- function() { Sys.unsetenv('TILEDB_CLOUD_R_HTTP_DEBUG') }

dtt  <- function() { devtools::test() }

rfoo <- function() { source("foo.r") }

local({
   r <- getOption("repos");
   r["CRAN"] <- "https://cloud.r-project.org"
   options(repos=r)
})

options(download.file.method = 'libcurl' , HTTPUserAgent = 'R/4.3.2 R (4.3.2 x86_64-pc-linux-gnu x86_64 linux-gnu)' ) 
local({
   r <- getOption("repos");
   r["CRAN"] <- "https://cloud.r-project.org"
   options(repos=r)
})
local({
   r <- getOption("repos");
   r["CRAN"] <- "https://cloud.r-project.org"
   options(repos=r)
})
