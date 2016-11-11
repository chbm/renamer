library("dplyr")
library("stringr")

names <- c("utils-1_importer.R", "utils-2_exporter.R", "1_main.R", "2_explore.R")
new_name <- "1-utils_constants.R"


add_script <- function(name, wd = getwd(), renumber = FALSE) {
  lookaround_int <- "(?<=\\D)(?=\\d)|(?<=\\d)(?=\\D)"
  lookbehind_int <- "(?<=\\D)(?=\\d)"
  regex_int <- "[0-9]*[0-9]"
  
  if (grepl(lookaround_int , name, perl = TRUE)) {
    split_name <- str_split(name, lookaround_int) %>% unlist()
    number <- subset(split_name, grepl(pattern = regex_int, split_name))
    split_name_pattern <- str_split(name, lookbehind_int) %>% unlist()
    pattern <- ifelse(length(split_name_pattern) == 1, NA_character_, first(split_name_pattern))
    files_wd <- list_files(number, wd, pattern)
    file_number_grepl <- grepl(number, files_wd)
    
    if(any(file_number_grepl)) {
      file_conflict <- files_wd[which(file_number_grepl)]
      if (!renumber){
        stop(str_c("Script number in ", name, " clashes with ",
                    file_conflict,
                    ". Set renumber flag to TRUE to renumber scripts."))
      } else {
        renumber_files(number, wd, pattern)
      }
    }
  }
  if(grepl(".*\\.R$", name)) {
    file.edit(name)
  } else {
    file.edit(str_c(name, ".R"))
    }
}

# auxiliary function
renumber_files <- function(starting_number, wd = getwd(), pattern = NA_character_) {
  print("TODO!")
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
  
  return(scripts)
}
