# Unsupervised with PCA to detect abnomalies
# We can use df_final 
# Drop the "isFraud" column from test
df_final <- df_final[, !names(df_final) %in% "isFraud"]

# PCA with h2o
# initilization with max ram
library(h2o)
h2o.init(max_mem_size='6G') 
df_final <- as.h2o(df_final)

# Build and train the model:
pca <- h2o.prcomp(training_frame = df_final,
                  k = 2,
                  use_all_factor_levels = TRUE,
                  pca_method = "Randomized",
                  transform = "STANDARDIZE",
                  impute_missing = TRUE)

pred_pca=h2o.predict(pca,df_final)

# Calculate the z-score for each principal component
z_scores <- h2o.scale(pred_pca, center = FALSE, scale = FALSE) # I prefered not to scale and centered the data because or data are financial data

# Set a threshold for z-scores to identify outliers
threshold <- 13 # I adjusted this treshold to detect data. We can also use for loop to optimize it.
final_results=h2o.cbind(df_final,z_scores)

# Identify outliers based on z-scores
outliers <- final_results[h2o.abs(z_scores$PC1) > threshold |
                            h2o.abs(z_scores$PC2) > threshold, ]
# Change the h2o datafram to R dataframe 
outliers=as.data.frame(outliers)

# Graph the predicted PCAs
ggplot() +
  geom_point(data = as.data.frame(final_results), aes(x = PC1, y = PC2), color = "green") +
  geom_point(data = as.data.frame(outliers), aes(x = PC1, y = PC2), color = "red") +
  xlab("PC1") +
  ylab("PC2") +
  ggtitle("Outliers vs. Data Points")


