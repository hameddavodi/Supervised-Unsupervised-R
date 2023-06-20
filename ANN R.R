### ANN Prediction
# Convert the target variable to a factor
train_data$isFraud <- as.factor(train_data$isFraud)

# Load the h2o library and initialize the H2O cluster
library(h2o)
h2o.init(max_mem_size="6G")
num_cores <- 4 # these two lines is for parallel computing when we dont want to use max_mem
h2o.init(nthreads = num_cores)

# Convert the training and test data to H2O frames
train_h2o <- as.h2o(train_data)
test_h2o <- as.h2o(test_data)

# Define predictors and response variable
predictors <- setdiff(names(train_data), "isFraud")
response <- "isFraud"

# Train the deep learning model using H2O
ann <- h2o.deeplearning(
  x = predictors,
  y = response,
  training_frame = train_h2o,
  activation = "Rectifier",
  hidden = c(10, 10),  # Number of neurons 
  epochs = 1000,        # Number of training iterations
  variable_importances = TRUE)  # Calculate variable importances

# Make predictions on the test data using the trained model
predictions <- h2o.predict(ann, newdata = test_h2o)

# Calculate the accuracy of the predictions
accuracy <- mean(predictions$predict == test_h2o$isFraud)
h2o.shutdown()
