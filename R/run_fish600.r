#' Master function to run the FISH600-specific simulations
#'
#' This function first deals with parsing the case input files and
#' then passes these arguments on to \code{\link{run_ss3sim}}.
#'
#' @examples
#' \dontrun{
#' # Pull in file paths from the package example data:
#' d <- system.file("extdata", package = "ss3sim")
#' f <- paste0(d, "/run_ss3sim_eg/")
#' om_model_dir <- paste0(f, "cod_om")
#' em_model_dir <- paste0(f, "cod_em")
#' case_folder <- paste0(f, "case-arguments")
#'
#' # Without bias correction:
#' run_fish600(iterations = 1, scenarios = c("M1-F1-D1-R1-cod"),
#' case_folder = case_folder, om_model_dir = om_model_dir,
#' em_model_dir = em_model_dir)
#'
#' # With bias correction:
#' # (Note that bias_nsim should be bigger, say 5, but it is set to 1
#' here so the example runs faster.)
#' run_fish600(iterations = 1, scenarios = c("M1-F1-D1-R1-cod"),
#' case_folder = case_folder, om_model_dir = om_model_dir,
#' em_model_dir = em_model_dir, bias_correct = TRUE,
#' bias_nsim = 1)
#' }

run_fish600 <- function(iterations, scenarios, case_folder,
  om_model_dir, em_model_dir, ...) {

  lapply(scenarios, function(x) {
    a <- get_caseargs(folder = case_folder, scenario = x) 

    run_ss3sim(iterations, scenarios = x, m_params = a$M,
      f_params = a$F, index_params = a$index, lcomp_params = a$lcomp,
      agecomp_params = a$agecomp, om_model_dir = om_model_dir,
      em_model_dir = em_model_dir, ...) 
  })

}

