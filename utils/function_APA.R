options(to_round = 2)
options(effect_size = "ges")

lm_output <- function(model, effect_name = -1, to_round = options()$to_round){
  #' Show the output of a linear model in APA format
  #'
  #' @description Take a linear model (from the function lm) and show the textual output in APA format
  #'
  #' @param model the model to summarize
  #' @param effect_name the name of the effect that you wanna show
  #' @param to_round the number of digits to round the results to
  #'
  #' @return a string with the output in APA format
  stopifnot(effect_name != -1)
  res <- summary(model)
  stopifnot("Effect name not found in the effect"=effect_name %in% rownames(res$coefficients))

  tab <- res$coefficients[rownames(res$coefficients) == effect_name,]
  est <- sprintf('%.*f', to_round, tab["Estimate"])
  t <- sprintf('%.*f', to_round, tab["t value"])
  p <- tab[stringr::str_detect(names(tab), "Pr")]
  df <- res$df[2]
  p_str <- process_p_value(p)
  CI <- confint(model)[effect_name,]
  return(
    paste(
      "_b_ = ", est,
      ", _t_(", df,")", " = ", t,
      ", _p_ ", p_str,
      ", CI95%[", sprintf('%.*f', to_round, CI[[1]]), "; ",sprintf('%.*f', to_round, CI[[2]]), "]", sep = ""))
}

ANOVA_output <- function(model, effect_name, to_round = options()$to_round){
  #' Show the output of an ANOVA in APA format
  #' 
  #' @description Take an ANOVA and show the textual output in APA format for the given effect
  #' 
  #' @param model: the model to summarize
  #' @param effect_name: the name of the effect that you wanna show
  #' @param to_round: the number of digits to round the results to
  #' 
  #' Note: this function works with ANOVA output but also from the afex package (aov_ez function) 
  
  if (class(model)[1] == "afex_aov"){
    coef <- process_afex_aov(model, effect_name)
  } else {
    coef <- model[model$Effect == effect_name,]
  }
  
  f <- sprintf('%.*f', to_round, coef[,"F"])
  ddl_n <- coef[,"DFn"]
  ddl_d <- coef[,"DFd"]
  p <- coef[,"p"]
  p_str <- process_p_value(p)
  ges <- coef$effect_size
  ges_str <- process_eta2(ges)
  CI <- confint(model)[effect_name,]
  return(paste(
    "_F_(",ddl_n, ", ", ddl_d, ") = ", f, ", _p_ ", p_str,
    ", $eta_{p}^2$ = ", ges_str,
    sep = ""
  ))
}

glmmtmb_output <- function(model, effect_name, to_round = options()$to_round, CI){
  #' Show the output of a generalized linear mixed model based on the package glmmTMB in APA format
  #' 
  #' @param model the model to summarize
  #' @param effect_name the name of the effect that you wanna show
  #' @param to_round the number of digits to round the results to
  #' @param CI is the output of the confint function
  res <- summary(model)
  stopifnot("Effect name not found in the effect"=effect_name %in% rownames(res$coefficients))

  tab <- res$coefficients$cond[rownames(res$coefficients) == effect_name,]
  est <- round(tab["Estimate"], to_round)
  z <- round(tab["z value"], to_round)
  p_str <- process_p_value(tab["Pr(>|z|)"])
  CI <- CI[effect_name,]
  if (abs(CI[[1]]) > abs(CI[[2]])){
    return("The first confidence interval can't be higher than the second")
  }
  return(paste(
    "_b_ = ", est,
    ", _z_", " = ", z,
    ", _p_ ", p_str,
    ", CI95%[", sprintf('%.*f', to_round, CI[[1]]), 
      "; ",sprintf('%.*f', to_round, CI[[2]]), "]", sep = ""))
}

lmer_output <- function(model, effect_name, to_round = options()$to_round, CI){
  #' Show the output of a linear mixed model based on the package lme4 in APA format
  #' 
  #' @param model the model to summarize
  #' @param effect_name the name of the effect that you wanna show
  #' @param to_round the number of digits to round the results to
  #' @param CI is the output of the confint function
  require(lmerTest)
  model <- as_lmerModLmerTest(model)
  res <- summary(model)
  stopifnot("Effect name not found in the effect"=effect_name %in% rownames(res$coefficients))
  tab <- res$coefficients[rownames(res$coefficients) == effect_name,]
  est <- round(tab["Estimate"], to_round)
  df <- round(tab["df"], to_round)
  t <- round(tab["t value"], to_round)
  p_str <- process_p_value(tab[stringr::str_detect(names(tab), "Pr")])
  CI <- CI[effect_name,]
  return(paste(
    "_b_ = ", est,
    ", _t_(", df,")", " = ", t,
    ", _p_ ", p_str,
    ", CI95%[", sprintf('%.*f', to_round, CI[[1]]), "; ",sprintf('%.*f', to_round, CI[[2]]), "]", sep = ""))
}

glmer_output <- function(model, effect_name, to_round = options()$to_round, CI){
  #' Show the output of a generalized linear mixed model based on the package lme4 in APA format
  #' 
  #' @param model the model to summarize
  #' @param effect_name the name of the effect that you wanna show
  #' @param to_round the number of digits to round the results to
  #' @param CI is the output of the confint function
  require(lmerTest)

  res <- summary(model)
  stopifnot("Effect name not found in the effect"=effect_name %in% rownames(res$coefficients))
  tab <- res$coefficients[rownames(res$coefficients) == effect_name,]
  est <- round(tab["Estimate"], to_round)
  df <- round(tab["df"], to_round)
  z <- round(tab["z value"], to_round)
  p_str <- process_p_value(tab[stringr::str_detect(names(tab), "Pr")])
  CI <- CI[effect_name,]
  return(paste(
    "_b_ = ", est,
    ", _z_ = ", z,
    ", _p_ ", p_str,
    ", CI95%[", sprintf('%.*f', to_round, CI[[1]]), "; ",sprintf('%.*f', to_round, CI[[2]]), "]", sep = ""))
}

value_output <- function(mean, sd, to_round = 2) {
  #' Show the mean and standard deviation in APA format
  #' 
  #' @param mean the mean to show
  #' @param sd the standard deviation to show
  return(paste(
    "(_M_ = ", round(mean, to_round), 
    ", _SD_ = ", round(sd, to_round), ")", sep = "")
  )
}

process_afex_aov <- function(model, eff){
  aov_table <- model$anova_table
  aov_table <- dplyr::rename(aov_table, 
                             "DFn" = "num Df", 
                             "DFd" = "den Df",
                             "p" = "Pr(>F)")
  return(aov_table[eff,])
}

process_p_value <- function(p, to_round = options()$to_round){
  if (p < .001) {
    p_str <- "< .001"
  } else if (p < .1){
    p_str <- paste("= ", sub(".", "", as.character(sprintf('%.*f', to_round, p))), sep = "")
    # To delete the first character
  } else {
    p_str <- paste("= ", sub(".", "", as.character(sprintf('%.*f',to_round, p))), sep = "")
  }
  return(p_str)
}
process_eta2 <- function(pes){
  if (pes == 0) {
    pes_str <-  "0"
  } else {
    pes_str <- sub(".", "", as.character(sprintf('%.*f', to_round, pes)))
  }
  return(pes_str)
}
