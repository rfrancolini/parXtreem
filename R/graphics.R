
#' Plot PAR data as line plot
#'
#' @export
#' @param x tibble of parXtreem data
#' @param main character, title
#' @param xlabel character, title of xaxis
#' @param ylabel character, title of yaxis
#' @return ggplot2 object
draw_plot <- function(x = read_parXtreem(),
                      main = "PAR",
                      xlabel = "Date",
                      ylabel = "PAR (umols / m squared / second)"){

  ggplot2::ggplot(data = x, ggplot2::aes(x = .data$DateTime, y = .data$PAR)) +
    ggplot2::geom_line(na.rm = TRUE) +
    ggplot2::labs(title = main, x = xlabel, y = ylabel)

}


