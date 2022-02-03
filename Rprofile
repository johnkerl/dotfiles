.First <- function() {
  # print("You changed your R options")
  # options(error = traceback)
  options(repos = list(CRAN = "https://cran.rstudio.com"))
  if (interactive()) {
    library(tiledb)
    library(tiledbcloud)
    library(tinytest)
    library(future)
    namespace <<- 'johnkerl-tiledb'
    namespaceToCharge <<- namespace
    cat("tiledb:      ", toString(utils::packageVersion("tiledb")),      "\n")
    cat("tiledbcloud: ", toString(utils::packageVersion("tiledbcloud")), "\n")
    cat("tinytest:    ", toString(utils::packageVersion("tinytest")),    "\n")
    cat("future:      ", toString(utils::packageVersion("future")),      "\n")
    cat("namespace:   ", namespace, "\n")
  }
}
vers <- function() {
  print(packageVersion("tiledb"))
  print(packageVersion("tiledbcloud"))
}

t   <- function() { library(tiledb)        }
tc  <- function() { library(tiledbcloud)   }
d   <- function() { library(devtools)      }
dla <- function() { devtools::load_all()   }
rox <- function() { roxygen2::roxygenise() }
pbs <- function() { pkgdown::build_site()  }

tta  <- function() { tinytest::test_all(".")                                   }
tcue <- function() { tinytest::run_test_file("inst/tinytest/test_c_udf_execution.R") }
ttd1 <- function() { tinytest::run_test_file("inst/tinytest/test_a_delayed_1.R") }
ttd2 <- function() { tinytest::run_test_file("inst/tinytest/test_a_delayed_2.R") }
ttd3 <- function() { tinytest::run_test_file("inst/tinytest/test_a_delayed_3.R") }
ttd4 <- function() { tinytest::run_test_file("inst/tinytest/test_a_delayed_4.R") }
ttd5 <- function() { tinytest::run_test_file("inst/tinytest/test_d_delayed_5.R") }
ttd6 <- function() { tinytest::run_test_file("inst/tinytest/test_d_delayed_6.R") }
ttdr <- function() { tinytest::test_package("tiledb")                          }
ttdc <- function() { tinytest::test_package("tiledbcloud")                     }

rfoo <- function() { source("foo.r") }
