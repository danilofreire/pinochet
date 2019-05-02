# Deaths and Disappearances in the Pinochet Regime: A New Dataset

This Github repository contains data and documented R code for [Deaths and Disappearances in the Pinochet Regime: A New Dataset](https://osf.io/rm4y8) by Freire et al (2019). We coded the personal details of 2,398 victims named in the Chilean Truth Commission Report and added geographical coordinates for all identifiable atrocity locations. The dataset covers from 1973 to 1990 and includes XXXX variables with information about the victims and the perpetrators of violence during the Pinochet dictatorship. We show how to access the dataset below.

## Installation

The dataset is available both as an [Excel spreadsheet](http://github.com/danilofreire/pinochet/data/pinochet.xlsx) or as the `pinochet` package for `R`. The stable version of the package is on [CRAN](https://cran.r-project.org/package=pinochet) and you can install it with

```
install.packages("pinochet")
```

We plan to update the dataset by including information from other official sources. To install the latest version of the package, simply use

```
if (!require("devtools")) {
    install.packages("devtools")
}
devtools::install_github("danilo/pinochet")
```

## Variables

Our dataset includes personal details of 2398 victims of the Pinochet regime. The Chilean Truth and Commission Reports describes 

## Long and Wide Data Formats

We present the dataset in two formats, wide and long. In the wide data format, each row corresponds to a victim of the Pinochet regime and each column is one variable, such as last name or the age of the victim. Scholars looking for information about a particular individual may find the wide format useful. To download the data in wide format, type

```
library(pinochet) 

pinochet_wide() 
```

This is how a sample entry looks like:

```
pinochet[276,]
```











You can cite the manuscript as:

> Freire, Danilo; Meadowcroft, John; Skarbek, David; Guerrero, Eugenia. 2019. "Deaths and Disappearances in the Pinochet Regime: A New Dataset." https://osf.io/rm4y8

BibTeX entry:

```
@misc{freire2019pinochet,
  title={{Deaths and Disappearances in the Pinochet Regime: A New Dataset}},
  howpublished = {\url{https://osf.io/rm4y8}},
  publisher={Open Science Framework},
  author={Freire, Danilo and Meadowcroft, John and Skarbek, David and Guerrero, Eugenia},
  year={2019},
  month={May}
}
```
