PAR Xtreem
================

## parXtreem

This is for managing and understanding your PAR Odyssey Xtreem data

## Requirements

-   [R v4+](https://www.r-project.org/)
-   [dplyr](https://CRAN.R-project.org/package=dplyr)
-   [readr](https://CRAN.R-project.org/package=readr)
-   [stringr](https://CRAN.R-project.org/package=stringr)
-   [ggplot2](https://CRAN.R-project.org/package=ggplot2)

## Installation

    remotes::install_github("rfrancolini/parXtreem")

## Read Example Data

``` r
library(parXtreem)
x <- read_parXtreem()
x
```

    ## # A tibble: 9,166 x 5
    ##     Temp   PAR ID           logDateTime DateTime           
    ##    <dbl> <dbl> <chr>              <dbl> <dttm>             
    ##  1  19.6  20.5 FE23BC74DC01  1620990900 2021-05-14 11:15:00
    ##  2  19.9  81.8 FE23BC74DC01  1620991800 2021-05-14 11:30:00
    ##  3  19.9  79.4 FE23BC74DC01  1620992700 2021-05-14 11:45:00
    ##  4  16.4 535.  FE23BC74DC01  1620993600 2021-05-14 12:00:00
    ##  5  13.1   0   FE23BC74DC01  1620994500 2021-05-14 12:15:00
    ##  6  12    81.4 FE23BC74DC01  1620995400 2021-05-14 12:30:00
    ##  7  13.4  22.7 FE23BC74DC01  1620996300 2021-05-14 12:45:00
    ##  8  13.4  63.6 FE23BC74DC01  1620997200 2021-05-14 13:00:00
    ##  9  13.1  46.9 FE23BC74DC01  1620998100 2021-05-14 13:15:00
    ## 10  13.4  37.8 FE23BC74DC01  1620999000 2021-05-14 13:30:00
    ## # ... with 9,156 more rows

## Read Example Data with Defined Deploy/Recover Dates

``` r
d <- as.POSIXct("2021-05-15", "")
r <- as.POSIXct("2021-08-16", "")
xdr <- read_parXtreem(deploy = d, recover = r)
xdr
```

    ## # A tibble: 8,929 x 5
    ##     Temp   PAR ID           logDateTime DateTime           
    ##    <dbl> <dbl> <chr>              <dbl> <dttm>             
    ##  1  7.69 11.2  FE23BC74DC01  1621036800 2021-05-15 00:00:00
    ##  2  7.69  1.54 FE23BC74DC01  1621037700 2021-05-15 00:15:00
    ##  3  7.69  0.22 FE23BC74DC01  1621038600 2021-05-15 00:30:00
    ##  4  7.69  0    FE23BC74DC01  1621039500 2021-05-15 00:45:00
    ##  5  7.63  0    FE23BC74DC01  1621040400 2021-05-15 01:00:00
    ##  6  7.63  0    FE23BC74DC01  1621041300 2021-05-15 01:15:00
    ##  7  7.5   0    FE23BC74DC01  1621042200 2021-05-15 01:30:00
    ##  8  7.44  0    FE23BC74DC01  1621043100 2021-05-15 01:45:00
    ##  9  7.44  0    FE23BC74DC01  1621044000 2021-05-15 02:00:00
    ## 10  7.44  0    FE23BC74DC01  1621044900 2021-05-15 02:15:00
    ## # ... with 8,919 more rows

## Draw Example Plot

``` r
parplot <- draw_plot(xdr)
parplot
```

![](README_files/figure-gfm/parplot-1.png)<!-- -->
