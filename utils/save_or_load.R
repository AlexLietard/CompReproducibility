# This function has the purpose to avoid the long computation inside the Rmd
# file. If an object is already saved, then you should load it. Otherwise,
# run the expression (eval(exp)) and save the object.
save_or_load <- function(exp=expression(), path, FOLDER_ROBJECT){
  full_path <- paste(FOLDER_ROBJECT, path, sep = "")
  # If the object doesn't exist, create it
  if (!path %in% dir(FOLDER_ROBJECT)){
    res <- eval(exp, envir = parent.frame())
    saveRDS(res, file = full_path)
  } else {
    res <- readRDS(file = full_path)
  }
  return(res)
}