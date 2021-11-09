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
#' @param startstop POSIXt vector of two values or NA, only used if clip = "user"
#' @return tibble
clip_parXtreem <- function(x,
                          startstop = NA) {

  if (is.na(startstop)[1]) {
    x <- x %>% dplyr::mutate (Date = as.Date(.data$DateTime, tz = "UTC"),
                              DateNum = as.numeric(.data$DateTime))

    ix <- which(diff(x$Date) != 0)[1]  + 1
    firstday <- as.numeric(difftime(x$DateTime[ix], x$DateTime[1]))

    if (firstday < 23) {
      x <- x[-(1:(ix-1)),]
    }

    iix <- dplyr::last(which(diff(x$Date) != 0))  + 1
    lastday <- as.numeric(difftime(dplyr::last(x$DateTime),x$DateTime[iix]))

    if (lastday < 23) {
      x <- x[-((iix+1):nrow(x)),]
    }

    x <- x %>% dplyr::select(-.data$Date, -.data$DateNum)
  }


  if (!is.na(startstop)[1]) {
    x <- x %>%
      dplyr::filter(.data$DateTime >= startstop[1]) %>%
      dplyr::filter(.data$DateTime <= startstop[2])
  }

  x
}

#' read parXtreem data file
#'
#' @export
#' @param filename character, the name of the file
#' @param site character, site being read in
#' @param output character, the name for the outputted QAQC file
#' @param clipped character, if auto, removed partial start/end days. if user, uses supplied startstop days. if none, does no date trimming
#' @param startstop POSIXt vector of two values or NA, only used if clip = "user"
#' @return tibble
read_parXtreem <- function(filename = example_filename(),
                           site = NA,
                           output = NA,
                           clipped = c("auto", "user", "none")[1],
                           startstop = NA){
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


  x <- switch(tolower(clipped[1]),
              "auto" = clip_parXtreem(x, startstop = NA),
              "user" = clip_parXtreem(x, startstop = startstop),
              "none" = x,
              stop("options for clipped are auto, user, or none. what is ", clipped, "?")
  )

  if (!is.na(site)) {x <- x %>% dplyr::mutate(Site = site)}

  #omit NAs from data
  x <- na.omit(x)

  if (!is.na(output)) {
    readr::write_csv(x, file = output) }

  return(x)

}


#' print out summary of parXtreem data
#'
#' @export
#' @param x tibble, tibble of PAR data
#' @return tibble
summarize_parXtreem <- function(x = read_parXtreem()){

  #remove any NA's before summarizing
  #remove all 0 PAR items when calculating mean

  x <- na.omit(x)

  s <- x %>% dplyr::group_by(.data$Site) %>%
    dplyr::summarise(mean.par = mean(.data$PAR[.data$PAR!=0]),
                     first.day = dplyr::first(.data$DateTime),
                     last.day = dplyr::last(.data$DateTime),
                     max.PAR = max(.data$PAR),
                     max.PAR.date = .data$DateTime[which.max(.data$PAR)])

  return(s)
}



