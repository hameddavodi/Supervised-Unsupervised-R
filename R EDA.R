setwd("/Users/****/Desktop****/")
# Link to kaggle dataset https://www.kaggle.com/datasets/bannourchaker/frauddetection
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

# Also, it's better to drop unique IDs to avoid overfitting
df <- subset(data_normalized, select = -nameOrig)
df <- subset(df, select = -nameDest)
df <- subset(df, select = -step)

# The data is too big to be used and analyzed locally. To perform efficiently, we can create a subset of data

# Assuming your dataframe is named "df"
fraud_sample <- df[df$isFraud == 1, ] # Subset rows where isFraud is 1
fraud_sample <- fraud_sample[sample(nrow(fraud_sample), 500), ] # Randomly select 500 rows

notfraud <- df[df$isFraud == 0, ] # Subset rows where isFraud is 0
notfraud <- notfraud[sample(nrow(notfraud), 100000), ] # Randomly select 100,000 rows

df_final <- rbind.data.frame(fraud_sample, notfraud)
# Now let's look at the final data summary
# Generate summary statistics using the introduce() function
introduce(df_final)
plot_intro(df_final)
plot_bar(df_final)
plot_histogram(df_final)
plot_qq(df_final)
plot_qq(df_final, by = "type")
plot_correlation(na.omit(df_final), maxcat = 5L)
plot_prcomp(df_final, variance_cap = 0.9, nrow = 2L, ncol = 2L)
plot_boxplot(df_final, by = "type")
plot_scatterplot(df_final, by = "amount", sampled_rows = 1000L)
