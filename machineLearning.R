# Kaggle ML 2021
library(keras)
library(tfdatasets)
library(magick)

source('~/School/hackathon/hackathon/getcwd.R')
data_dir <- file.path(thisPath(), 'data')

training_path <- file.path(data_dir, "train.csv")
training_data <- read.csv(training_path, sep = ",", na.strings=c("","NA"), comment.char = "", header = T)

testing_path <- file.path(data_dir, "sampleSubmission.csv")
testing_data <- read.csv(testing_path, sep = ",", na.strings=c("","NA"), comment.char = "", header = T)

# ----------------------------------------------
train_images_dir <- file.path(data_dir, 'TrainImages')
train_images <- list.files(train_images_dir)

test_images_dir <- file.path(data_dir, 'TestImages')
test_images <- list.files(train_images_dir)

#---------------------CROP TRAINING IMAGES --------------------
train_image_crop <- function(image_dir, image_list){
  for (image_name in image_list){
    current_image_path <- file.path(image_dir, image_name)
    image <- image_read(current_image_path)
    image <- image_crop(image, "1024x840")
    image_write(image, path = current_image_path, format = "png")
  }
}

train_image_crop(train_images_dir, train_images)
#-------------------------------------------------------------


###########Load using tfdatasets
# To load the files as a TensorFlow Dataset first create a dataset of the file paths:
  
list_ds <- file_list_dataset(file_pattern = paste0(data_dir, "/*/*"))
list_ds %>% reticulate::as_iterator() %>% reticulate::iter_next()



get_label <- function(file_path) {
  parts <- tf$strings$split(file_path, "/")
  parts[-2] %>% 
    tf$equal(classes) %>% 
    tf$cast(dtype = tf$float32)
}

decode_img <- function(file_path, height = 1024, width = 840) {
  size <- as.integer(c(height, width))
  file_path %>% 
    tf$io$read_file() %>% 
    tf$image$decode_jpeg(channels = 3) %>% 
    tf$image$convert_image_dtype(dtype = tf$float32) %>% 
    tf$image$resize(size = size)
}

preprocess_path <- function(file_path) {
  list(
    decode_img(file_path),
    get_label(file_path)
  )
}

