# Deaths and Disappearances in the Pinochet Regime: A New Dataset

This Github repository contains data and documented R code for [Deaths and Disappearances in the Pinochet Regime: A New Dataset](https://osf.io/rm4y8) by Freire et al (2019). We coded the personal details of 2,398 victims named in the Chilean Truth Commission Report along with geographical coordinates for all identifiable atrocity locations and information about the perpetrators. The dataset covers from 1973 to 1990 and includes XXXXX indicators. Please refer to our [accompanying article](https://github.com/danilofreire/pinochet/manuscript/article.pdf) for more details.

## Installation

The dataset is available both as an [Excel spreadsheet](http://github.com/danilofreire/pinochet/data/pinochet.xlsx) and as the `pinochet` package for `R`. The stable version of the package is on [CRAN](https://cran.r-project.org/package=pinochet). You can install it with:

```
install.packages("pinochet")
```

We plan to update the dataset by including information from other official sources. To install the latest version of the package, simply use:

```
if (!require("devtools")) {
    install.packages("devtools")
}
devtools::install_github("danilo/pinochet")
```

## Variables

There are XXXX variables in our dataset. Most of them refer to information about the victims, such as gender, age, first and last name, and their political affiliation (if available). The Chilean Truth Commission Report, our main data source, also mentions some characteristics of the perpetrators when they could be identified. We include coordinates of latitude and longitude for all identifiable places used for torture or executions. We created a variable indicating whether the coordinates are exact or not. In some cases, the Truth Commission was not able to locate where the atrocities took place. We likewise indicate that the coordinates are approximate. 

Our [data codebook](https://github.com/danilofreire/pinochet/codebook.pdf) has a full description of the variables. You can quickly see the variable names with: 

```
names(pinochet)
```

## Long and Wide Data Formats

We present the dataset in two formats, wide and long. In the wide data format, each row corresponds to a victim of the Pinochet regime and each column is one variable, such as last name or the age of the victim. Scholars looking for information about a particular individual may find the wide format useful. To download the data in wide format, type:

```
library(pinochet) 

pinochet_wide() 
```

This is how a sample entry looks like:

```
pinochet[276,]
```

The wide format is the default. For convenience, the `pinochet` package also has a function that converts the dataset from wide to long format. Please type:

```
pinochet_long()
```

if the long format is more appropriate to your needs. Long data has a column for all variable types and additional columns for the values of those variables. You can see an example entry below:

```
pinochet[276,]
```

## Applications

To illustrate the potential uses of the package, we show some spatial and temporal variation of the data. We see that the Pinochet regime concentrated most of the violence in the first three months after the coup. The graph below describe time trends for the atrocities perpetrated by the dictatorship:

```
library(ggplot2)
```

We can also plot the geographical locations of the human rights abuses: 

```
library(rnaturalearth)
```

We believe our data open new topics of research. For instance, researchers can test whether the Pinochet regime has caused attitudinal changes in direct or indirect victims, the relationship between human rights abuses and post-regime levels of interpersonal violence, or investigate the connections between international legitimacy and domestic politics in repressive regimes. These questions are still discussed in the literature and our dataset provides a way to empirically test them.

We hope our dataset is useful for scholars interested in these and other questions, and that the information it contains elicits hypotheses not only about the Pinochet period, but about authoritarian governments more generally.

## Citation

You can cite the manuscript as:

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

If you use the `pinochet` package, you can cite it as:

```
citation("pinochet")
```


