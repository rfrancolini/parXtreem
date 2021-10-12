#' retreive example type parXtreem file name
#'
#' @export
#' @return filename
example_filename <- function(){
  system.file("exampledata/Little_Drisko_PAR.csv",
              package="parXtreem")
}

#' clip parXtreem table by date
#'
#' @export
#' @param x tibble, parXtreem
#' @param deploy POSIXt or NA, if not NA, clip data before this time
#' @param recover POSIXt or NA, if not NA, clip data before this time
#' @return tibble
clip_parXtreem <- function(x,
                            deploy = NA,
                            recover = NA) {

  if (!is.na(deploy)) {
    x <- x %>%
      dplyr::filter(DateTime >= deploy[1])
  }

  if (!is.na(recover)) {
    x <- x %>%
      dplyr::filter(DateTime <= recover[1])
  }

  x
}

#' read parXtreem data file
#'
#' @export
#' @param filename character, the name of the file
#' @param deploy POSIXt or NA, if not NA, clip data before this time
#' @param recover POSIXt or NA, if not NA, clip data before this time
#' @return tibble
read_parXtreem <- function(filename = example_filename(),
                            deploy = NA,
                            recover = NA){
  stopifnot(inherits(filename, "character"))
  stopifnot(file.exists(filename[1]))
  x <- suppressMessages(readr::read_csv(filename[1]))
  #cleaning up the header
  #PPFD = photosynthetic photon flux density
  h <- colnames(x)
  lut <- c("data2" = "Temp",
           "data1" = "PAR",
           "loggerUid" = "ID",
           "logDateTime" = "logDateTime",
           "dateTime" = "DateTime")
  colnames(x) <- lut[h]
  #adapted from: https://stackoverflow.com/questions/8613237/extract-info-inside-all-parenthesis-in-r
  #attr(x, "units") <- stringr::str_extract(h, "(?<=\\().*?(?=\\))")
  #attr(x, "filename") <- filename[1]
  #use the spec attr for original colnames
  #attr(x, "original_colnames") <- h

  #convert date/time to POSIXct format
  x$DateTime = as.POSIXct(x$DateTime, format = "%d-%m-%Y %H:%M")


  x <- clip_parXtreem(x,
                       deploy = deploy,
                       recover = recover)

  return(x)

}


