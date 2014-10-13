#' External estimation procedure for von Bertalanffy growth
#'
#' @export
#' @import bbmle
#TODO:
#Determine where n.samples should come from only using the data at hand
# i.e. if the number of samples is less than blah use blah
#document these functions
#make sure that when the package is loaded that these functions are available to change_e

  #Function to predict length given VBGF parameters
  vbgf_func <- function(L1, L2, k, ages, a3){
    predLength <- L2 + (L1 - L2) * exp(-k * (ages - a3))
    return(predLength)
  }


sample_fit_VBGF <- function(n.samples = NULL,length.data,start.L1,
                            start.L2,start.k,start.logsigma,a3,A){
  #function takes data, number of samples, start values, start age
  #Data must have colums ordered: Year, Length, Weight, Sex, age
  #Then fits VBGF to subsampled data
  #Remove fish younger than a3 and older than A
  length.data<-length.data[length.data[, 1] > a3, ]
  length.data<-length.data[length.data[, 1] < A, ]
  #lines.to.sample<-sample(1:nrow(length.data),size=n.samples,replace=FALSE)

  #Subsample data
  #ages<-length.data[lines.to.sample,1]
  #length.comp<-length.data[lines.to.sample,2]
  #length.df<-data.frame(cbind(ages,length.comp))
  
  #Returns the negative log likelihood function
  get_log_likelihood<-function(logL1,logL2,logk,logsigma){
    L1 <- exp(logL1)
    L2 <- exp(logL2)
    k <- exp(logk)
    sigma <- exp(logsigma)*length.df[,1]
    predLength <- vbgf_func(L1,L2,k,length.df[,1],a3)
    logLik <- sum(-log(sigma)-((log(predLength)-log(length.df[,2]))^2)/(2*sigma^2))
    return(-logLik)
  }
  #Fit using MLE
  mod <- bbmle::mle2(get_log_likelihood,start=list(logL1=start.L1,logL2=start.L2,logk=start.k,logsigma=start.logsigma))
  return(mod)
}
