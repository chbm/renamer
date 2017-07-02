#' Add a new script to folder
#'
#' @param name String with name of the new file to create.
#' @param wd Path where to create new R script, defaults to working directory.
#' @param renumber Boolean. Default is FALSE. If the script name has a number which creates conflicts with existing scripts, you will need to set this parameter o TRUE in order to rename all necessary files.

#' @export
#' @importFrom utils file.edit
#' @importFrom stringr str_split str_c str_pad str_sub
#' @importFrom dplyr "%>%"
add_script <- function(name, wd = getwd(), renumber = FALSE) {
  lookaround_int <- "(?<=\\D)(?=\\d)|(?<=\\d)(?=\\D)"
  lookbehind_int <- "(?<=\\D)(?=\\d)"
  regex_int <- "[0-9]*[0-9]"

  if (grepl(lookaround_int , name, perl = TRUE)) {
    split_name <- str_split(name, lookaround_int) %>% unlist()
    number <- subset(split_name, grepl(pattern = regex_int, split_name))
    split_name_pattern <- str_split(name, lookbehind_int) %>% unlist()
    pattern <- ifelse(length(split_name_pattern) == 1, NA_character_, first(split_name_pattern))
    files_wd <- .list_files(number, wd, pattern)
    file_number_grepl <- grepl(number, files_wd)

    if(any(file_number_grepl)) {
      file_conflict <- files_wd[which(file_number_grepl)]
      if (!renumber){
        stop(str_c("Script number in ", name, " clashes with ",
                    file_conflict,
                    ". Set renumber flag to TRUE to renumber scripts."))
      } else {
        .renumber_files(number, files_wd, wd, pattern)
      }
    }

    if(grepl(".*\\.R$", name)) {
      file.edit(name)
    } else {
      file.edit(str_c(name, ".R"))
    }


  }
}

#' @importFrom stringr str_split str_c str_pad str_sub
#' @importFrom dplyr "%>%"
.renumber_files <- function(starting_number, files, wd = getwd(), pattern = NA_character_) {
  lookaround_int <- "(?<=\\D)(?=\\d)|(?<=\\d)(?=\\D)"
  for (i in seq_along(files)) {
    name <- files[i]
    split_name <- str_split(name, lookaround_int) %>% unlist()
    number_index <- `if`(is.na(pattern), 1, 2)

    number_file <- split_name[number_index]
    zero_pad <- str_sub(number_file, start = 1L, end = 1L) == 0 & nchar(number_file) == 2

    if (zero_pad & as.numeric(number_file) != 9){
      new_number <- str_pad(as.numeric(number_file) + 1, width = 2, pad = 0)
    } else {
      new_number <- as.numeric(number_file) + 1
    }
    new_name_parts <- c(new_number, split_name[number_index + 1])
    if (!is.na(pattern)) {
      new_name_parts <- c(pattern, new_name_parts)
    }
    new_name <- str_c(new_name_parts, collapse = "")
    file.rename(name, new_name)
  }
}


#' @importFrom stringr str_split str_c str_pad str_sub
#' @importFrom dplyr "%>%"
.list_files <- function(starting_number, wd = getwd(), pattern = NA_character_) {
  starting_vec <- str_split(starting_number, "") %>% unlist() %>% as.numeric()
  if (length(starting_vec) == 1) {
    default_pattern <- str_c("[", starting_vec, "-9]|[1-9][0-9].*\\.R$")
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
