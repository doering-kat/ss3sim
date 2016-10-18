context("run_ss3sim with time-varying parameters")

# Tests are skipped on CRAN because the SS3 executable won't be available
temp_path <- file.path(tempdir(), "test-timevarying")
dir.create(temp_path, showWarnings = FALSE)
wd <- getwd()
setwd(temp_path)

d <- system.file("extdata", package = "ss3sim")
om <- paste0(d, "/models/cod-om")
em <- paste0(d, "/models/cod-em")
case_folder <- paste0(d, "/eg-cases")

test_that("A scenario with time-varying M runs.", {
  skip_on_cran()
  run_ss3sim(iterations = 1, scenarios = "D0-F0-M0-cod",
    case_files = list(F = "F", D = c("index", "lcomp", "agecomp"),
      M = "M"),
    case_folder = case_folder, om_dir = om, em_dir = em, ss_mode = "optimized")
  temp <- r4ss::SS_readstarter(verbose = FALSE,
    file = file.path("D0-F0-M0-cod", "1", "om", "starter.ss"))
  expect_equal(temp$init_values_src, 1)
  temp <- r4ss::SS_readdat(verbose = FALSE, echoall = FALSE,
    file = file.path("D0-F0-M0-cod", "1", "om", "ss3.dat"))
  expect_equal(temp$envdat$Value, rep(0, 100))
  unlink("D0-F0-M0-cod", recursive = TRUE) # clean up
})

setwd(wd)
