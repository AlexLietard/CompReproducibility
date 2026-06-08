# If first time run
library(dplyr)
library(ggplot2)
library(tidyr)

# Load all functions in utils folder
path <- c("./utils")
for (p in path) {
  utils_fn <- list.files(p, full.names = TRUE, pattern = "\\.R$", 
                         recursive = FALSE)
  for (fn in utils_fn) {
    print(paste(fn, "loaded"))
    source(fn)
  }
}

# Generate data
# data_1 <- rnorm(100, 1, 0.2)
# data_2 <- rnorm(100, 0.6, 0.2)
# df <- data.frame(
#   value = c(data_1, data_2),
#   group = factor(rep(c("training", "non_training"), each = 100))
# )
# df$id <- 1:nrow(df)
# write.csv(df, "data.csv", row.names = FALSE)

df <- read.csv("data.csv")
