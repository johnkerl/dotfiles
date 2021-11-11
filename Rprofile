.First <- function() {
  # print("You changed your R options")
  # options(error = traceback)
  options(repos = list(CRAN = "https://cran.rstudio.com"))
  library(tiledb)
}
t <- function() {
  library(tiledb)
}
d <- function() {
  library(devtools)
}
dla <- function() {
  devtools::load_all()
}
pp2 <- function() {
  arr <<- tiledb_array("~/data/palmer_penguins2", return_as="data.frame")
  sch <<- schema(arr)
  dom <<- domain(sch)
}
