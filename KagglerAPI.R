# Kaggle API 
# install.packages("devtools")
# library(devtools)
# install_github("mkearney/kaggler")

library(kaggler)
kgl_auth(username = "jbourret", key = "5b196d05bb9a0d13327d29b2ae4a9922")

comps1 <- kgl_competitions_list()
comps1