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
test_images <- list.files(test_images_dir)

#---------------------CROP TRAINING IMAGES --------------------
# https://cran.r-project.org/web/packages/magick/vignettes/intro.html#Read_and_write
# train_image_crop <- function(image_dir, image_list){
#   for (image_name in image_list){
#     current_image_path <- file.path(image_dir, image_name)
#     image <- image_read(current_image_path)
#     image <- image_crop(image, "1024x840")
#     image_write(image, path = current_image_path, format = "png")
#   }
# }
# 
# train_image_crop(train_images_dir, train_images)
#-------------------------------------------------------------

# https://www.shirin-glander.de/2018/06/keras_fruits/
img_width <- 840
img_height <- 1024
target_size <- c(img_width, img_height)
channels <- 1

train_data_gen <- image_data_generator(
  rescale = 1/255 #,
  #rotation_range = 40,
  #width_shift_range = 0.2,
  #height_shift_range = 0.2,
  #shear_range = 0.2,
  #zoom_range = 0.2,
  #horizontal_flip = TRUE,
  #fill_mode = "nearest"
)

valid_data_gen <- image_data_generator(
  rescale = 1/255
) 

#--load images into memory
# https://www.rdocumentation.org/packages/keras/versions/2.3.0.0/topics/flow_images_from_directory
# flow_images_from_directory(
#   directory,
#   generator = image_data_generator(),
#   target_size = c(256, 256),
#   color_mode = "grayscale",
#   classes = NULL,
#   class_mode = "categorical",
#   batch_size = 32,
#   shuffle = TRUE,
#   seed = NULL,
#   save_to_dir = NULL,
#   save_prefix = "",
#   save_format = "png",
#   follow_links = FALSE,
#   subset = NULL,
#   interpolation = "nearest"
# )
# training images
train_image_array_gen <- flow_images_from_directory(train_images_dir, 
                                                    train_data_gen,
                                                    target_size = target_size,
                                                    class_mode = "categorical",
                                                    color_mode = "grayscale",
                                                    classes = NULL,
                                                    seed = 42)#,
                                                    # save_format = "png")

# validation images
valid_image_array_gen <- flow_images_from_directory(test_images_dir, 
                                                    valid_data_gen,
                                                    target_size = target_size,
                                                    color_mode = "grayscale",
                                                    class_mode = "categorical",
                                                    classes = NULL,
                                                    seed = 42)

train_classes_indices <- train_image_array_gen$class_indices
save(train_classes_indices, file = file.path(data_dir, "train_classes_indices.RData"))


#----- Configuring Layers of the model ----
model <- keras_model_sequential()
model %>%
  layer_flatten(input_shape = c(28, 28)) %>% # change the 2d array of the image into a 1d array to feed into the network
  layer_dense(units = 2048, activation = 'relu') %>%
  layer_dense(units = 4, activation = 'softmax') # corresponds to the number of classifications we want, For the xrays, itll be 4 of them?

#----- Compile the model --------
model %>% compile(
  optimizer = 'adam',      # how the model is updated based on data and loss function
  loss = 'sparse_categorical_crossentropy',   # loss function, want to minimize this to steer the model in the right direction
  metrics = c('accuracy')  # used to monitor the training and testing steps
)

#------ Train the model on the data ------
model %>% fit(train_images, train_labels, epochs = 5, verbose = 2)

score <- model %>% evaluate(test_images, test_labels, verbose = 0) # using the test data
# cat('Test loss:', score$loss, "\n")
# cat('Test accuracy:', score$acc, "\n")
print(score)










