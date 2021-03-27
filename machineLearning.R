# Kaggle ML 2021
library(keras)
library(here)
# library(tfdatasets)

data_dir <- file.path(getwd(), 'data')

training_path <- file.path(data_dir, "train.csv")
training_data <- read.csv(training_path, sep = ",", na.strings=c("","NA"), comment.char = "", header = T)

testing_path <- file.path(data_dir, "sampleSubmission.csv")
testing_data <- read.csv(training_path, sep = ",", na.strings=c("","NA"), comment.char = "", header = T)

# ----------------------------------------------
train_images_dir <- data_dir #file.path(data_dir, 'TrainImages')
images <- list.files(getwd())
length(images)
