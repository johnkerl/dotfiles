.First <- function() {
  # print("You changed your R options")
  # options(error = traceback)
  options(repos = list(CRAN = "https://cran.rstudio.com"))
  if (interactive()) {
    library(tiledb)
    library(tiledbcloud)
    print(utils::packageVersion("tiledb"))
    print(utils::packageVersion("tiledbcloud"))
  }
}
vers <- function() {
  print(packageVersion("tiledb"))
  print(packageVersion("tiledbcloud"))
}
t <- function() {
  library(tiledb)
}
tc <- function() {
  library(tiledbcloud)
}
d <- function() {
  library(devtools)
}
dla <- function() {
  devtools::load_all()
}
rox <- function() {
  roxygen2::roxygenise()
}
pbs <- function() {
  pkgdown::build_site()
}
pp2 <- function() {
  arr <<- tiledb_array("~/data/palmer_penguins2", return_as="data.frame")
  sch <<- schema(arr)
  dom <<- domain(sch)
}
ttdr <- function() {
  tinytest::test_package("tiledb")
}
ttdc <- function() {
  tinytest::test_package("tiledbcloud")
}
