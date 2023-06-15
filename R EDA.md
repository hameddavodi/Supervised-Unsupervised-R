setwd("/Users/hamed/Desktop/R ML projects/")

library(data.table)
library(dplyr)
library(psych)
library(dbplyr)
library(ff)
library(bigmemory)
library(biganalytics)
library(caret)
library(ggplot2)
library(glmnet)
library(DataExplorer)

data <- fread("Dataset.csv")
data <- as.data.frame(data)

# Perform label encoding
data$type <- as.integer(factor(data$type))
data$nameOrig <- as.integer(factor(data$nameOrig))
data$nameDest <- as.integer(factor(data$nameDest))

# Data normalizing and finding NA values
# Check for missing values column-wise
missing_values <- colSums(is.na(data))

# Normalizing using Z score
# Select the columns to be normalized
columns_to_normalize <- c("amount", "oldbalanceOrig", "oldbalanceDest", "newbalanceOrig", "newbalanceDest")

# Apply min-max normalization to the selected columns because other methods may cause some issues on data
data_normalized <- data

for (column in columns_to_normalize) {
  min_val <- min(data[[column]])
  max_val <- max(data[[column]])
  data_normalized[[column]] <- (data[[column]] - min_val) / (max_val - min_val)
}
