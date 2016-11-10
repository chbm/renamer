library("dplyr")
library("stringr")

names <- c("utils-1_importer.R", "utils-2_exporter.R", "1_main.R", "2_explore.R")
new_name <- "01-utils_constants.R"

str_split(new_name, "(?<=\\D)(?=\\d)|(?<=\\d)(?=\\D)")
add_script <- function(name, wd = getwd()) {
  regex_int <- "[0-9]*[0-9]"
  if (!grepl(regex_int , name)) {
    file.edit(str_c(name, ".R"))
  } else {
    
  }
}

# auxiliary function
renumber_files <- function(starting_number, wd = getwd(), pattern = NA_character_) {
}



# auxiliary function
list_files <- function(starting_number, wd = getwd(), pattern = NA_character_) {
  starting_vec <- str_split(starting_number, "") %>% unlist() %>% as.numeric()
  
  if (length(starting_vec) == 1) {
    default_pattern <- str_c("[0]*[", starting_vec, "-9]|[1-9][0-9].*\\.R$")
  } else if (length(starting_vec) == 2) {
    default_pattern <-
      str_c(starting_vec[1], "[", starting_vec[2], "-9]|[", starting_vec[1] + 1, "-9][0-9].*\\.R$")
  } else {
    stop("max starting_number is 99")
  }
  
  if (is.na(pattern)) {
    final_pattern <- str_c("^", default_pattern)
  } else {
    final_pattern <- str_c("^", pattern, ".*", default_pattern)
  }
  scripts <- list.files(wd, pattern = final_pattern)
}