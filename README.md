# Deaths and Disappearances in the Pinochet Regime: A New Dataset

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/pinochet)](https://cran.r-project.org/package=pinochet) 
[![Travis-CI Build
Status](https://travis-ci.org/danilofreire/pinochet.svg?branch=package)](https://travis-ci.org/danilofreire/pinochet)
[![DOI](https://zenodo.org/badge/103286196.svg)](https://zenodo.org/badge/latestdoi/103286196)
[![](http://cranlogs.r-pkg.org/badges/grand-total/pinochet?color=blue)](https://cran.r-project.org/package=pinochet)

This Github repository contains data and documented R code for [Deaths and Disappearances in the Pinochet Regime: A New Dataset](https://doi.org/10.31235/osf.io/vqnwu) by Freire et al (2019). We coded the personal details of 2,398 victims named in the Chilean Truth Commission Report along with information about the perpetrators and geographical coordinates for all identifiable atrocity locations. The dataset covers from 1973 to 1990 and includes 59 indicators. Please refer to our [accompanying article](https://doi.org/10.31235/osf.io/vqnwu) and our [online appendix](https://osf.io/8fkxq) for more details.

This branch has the data and code for the main article. The source code for the `pinochet` `R` package is available in the [package branch of this repository](https://github.com/danilofreire/pinochet/tree/package).

## Installation

The dataset is available in three formats: as an [Excel spreadsheet](https://github.com/danilofreire/pinochet/raw/master/data/pinochet.xlsx), a [`csv` file](https://raw.githubusercontent.com/danilofreire/pinochet/master/data/pinochet.csv),  and as the [`pinochet` package for `R`](http://github.com/danilofreire/pinochet/tree/package). The stable version of the package is on [CRAN](https://cran.r-project.org/package=pinochet). You can install it with:

```
install.packages("pinochet")
```

We plan to update the dataset by including information from other official sources. To install the latest version of the package, simply use:

```
if (!require("devtools")) {
    install.packages("devtools")
}
devtools::install_github("danilofreire/pinochet", ref = "package")
```

Then load the dataset with:

```
library(pinochet)
data(pinochet)
```

## Variables

There are 59 variables in our dataset. Most of them refer to information about the victims, such as gender, age, first and last name, and their political affiliation (if available). The Chilean Truth Commission Report, our main data source, also mentions some characteristics of the perpetrators when they could be identified. We include coordinates of latitude and longitude for all identifiable places used for torture or executions. We created a variable indicating whether the coordinates are exact or not. In some cases, the Truth Commission was not able to locate where the atrocities took place. We likewise indicate that the coordinates are approximate. 

Our [data codebook](https://osf.io/8fkxq) has the description of the variables. You can quickly see the variable names with: 

```
names(pinochet)
```

## Applications

To illustrate the potential uses of the package, we show some spatial and temporal variation of the data. We see that the Pinochet regime concentrated most of the violence in the first three months after the coup. The graph below describe time trends for the atrocities perpetrated by the dictatorship:

```
# Install necessary packages
if (!require("tidyverse")) {
        install.packages("tidyverse")
}
if (!require("lubridate")) {
        install.packages("lubridate")
}

# Plot
pinochet %>% 
  ungroup() %>% 
  mutate(Year = year(start_date_monthly)) %>%
  group_by(Year) %>% tally() %>% 
  filter(!is.na(Year)) %>% 
  ggplot(aes(x = Year, y = n)) +
  geom_line() +
  theme_minimal() +
  labs(x = NULL, y = NULL, title = "Number of Human Rights Abuses", 
       subtitle = "Pinochet Regime, 1973-1990") +
  scale_y_continuous(breaks = c(0, 500, 1000, 1274))
```

!["Human rights abuses in the Pinochet regime, 1973-1990"](https://github.com/danilofreire/pinochet/raw/master/figures/time-trend.png)

We can also plot the geographical locations of the human rights abuses: 

```
# Load necessary packages
if (!require("sf")) {
        install.packages("sf")
}
if (!require("devtools")) {
        install.packages("devtools")
}
devtools::install_github("ropensci/rnaturalearthdata")
if (!require("rnaturalearthhires")) {
        install.packages("rnaturalearthhires",
                         repos = "http://packages.ropensci.org",
                         type = "source")
}
library(rnaturalearthdata)
library(rnaturalearthhires)

# Save events
chile <- rnaturalearthhires::countries10 %>%
st_as_sf() %>%
filter(SOVEREIGNT %in% c("Chile", "Argentina", "Peru", "Paraguay"))

violent_events <- pinochet %>% 
  select(violence, latitude_1, longitude_1) %>%
  filter(!is.na(violence), !is.na(latitude_1), !is.na(longitude_1)) %>%
  st_as_sf(coords = c("longitude_1", "latitude_1"), crs = 5361) 

coords_vio <- st_coordinates(violent_events) %>% as_tibble()
violent_events <- bind_cols(violent_events, coords_vio)

# Create map
ggplot() +
  geom_sf(data = chile) +
  coord_sf(xlim = c(-75.6, -67), ylim = c(-55, -19)) +
  labs(x = NULL, y = NULL) +
  geom_point(data = violent_events, aes(x = X, y = Y,
                                        colour = violence,
                                        fill = violence),
             shape = 21) + 
  scale_colour_manual(values = c("#042333FF", "#481567FF",
                                 "#253582FF", "#2D708EFF",
                                 "#29AF7FFF")) +
  scale_fill_manual(values = alpha(c("#042333FF", "#481567FF",
                                     "#253582FF", "#2D708EFF",
                                     "#29AF7FFF"), .6)) +
  facet_wrap(~violence, nrow = 1) +
  theme_minimal() +
  theme(strip.text = element_blank()) +
  theme(legend.position = "bottom",
        axis.text = element_blank()) + 
  theme(legend.title=element_blank())
```

!["Spatial variation in human rights abuses in the Pinochet regime, 1973-1990"](https://github.com/danilofreire/pinochet/raw/master/figures/map.png)

We believe our data open new topics of research. For instance, researchers can test whether the Pinochet regime has caused attitudinal changes in direct or indirect victims, the relationship between human rights abuses and post-regime levels of interpersonal violence, or investigate the connections between international legitimacy and domestic politics in repressive regimes. These questions are still discussed in the literature and our dataset provides a way to empirically test them.

We hope our dataset is useful for scholars interested in these and other questions, and that the information it contains elicits hypotheses not only about the Pinochet period, but about authoritarian governments more generally. 

Contributions and suggestions are always welcome. Feel free to send me an email or to open an issue on GitHub.

## Citation

You can cite the manuscript as:

```
@misc{freire2019pinochet,
  title={{Deaths and Disappearances in the Pinochet Regime: A New Dataset}},
  howpublished = {\url{https://doi.org/10.31235/osf.io/vqnwu}},
  publisher={Open Science Framework},
  author={Freire, Danilo and Meadowcroft, John and Skarbek, David and Guerrero, Eugenia},
  year={2019},
  month={May}
}
```

If you use the `pinochet` package, you can cite it as:

```
@Manual{freire2019package,
    title = {pinochet: Packages data about the victims of the Pinochet regime},
    author = {Danilo Freire and Lucas Mingardi and Robert McDonnell},
    year = {2019},
    note = {R package version 0.1.0},
    url = {http://github.com/danilofreire/pinochet}
}
```
