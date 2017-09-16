###########################################################################
############ Deaths and Disappearances in the Pinochet Regime #############
### Danilo Freire, John Meadowcroft, David Skarbek and Eugenia Guerrero ###
###########################################################################

## Load required packages
if (!require("plyr")) {
        install.packages("plyr")
}
if (!require("tidyverse")) {
        install.packages("tidyverse")
}
if (!require("devtools")) {
        install.packages("devtools")
}
if (!require("narnia")) {
        install_github("njtierney/narnia")
}
if (!require("rnaturalearth")) {
        install.packages("rnaturalearth")
}

devtools::install_github("tidyverse/ggplot2")
library(ggplot2)

## Load data
df <- readr::read_csv("https://goo.gl/F1tgk1")

## Data manipulation
# Convert names to lowercase
names(df) <- tolower(names(df))

# Rename variables
df <- plyr::rename(df,
                   c("merged id" = "merged_id",
                     "start date" = "start_date",
                     "end date" = "end_date",
                     "last name" = "last_name",
                     "first name" = "first_name",
                     "sex (c)" = "female",
                     "occupation (c)" = "occupation",
                     "occupation" = "occupation_2",                     
                     "victim affiliation (c)" = "victim_affiliation",
                     "victim affiliation" = "victim_affiliation2",
                     "violence (c)" = "violence",
                     "method (c)" = "method",
                     "interrogation (c)" = "interrogation",
                     "torture (c)" = "torture",
                     "war tribunal" = "war_tribunal",
                     "previous arrests (#)" = "number_previous_arrests",
                     "perpetrator affiliation (c)" = "perpetrator_affiliation",
                     "place-1" = "place_1",
                     "start location-1" = "start_location_1",
                     "latitude-1" = "latitude_1",
                     "longitude-1" = "longitude_1",
                     "exact coordinates-1" = "exact_coordinates_1",
                     "place-2" = "place_2",
                     "location-2" = "location_2",
                     "latitude-2" = "latitude_2",
                     "longitude-2" = "longitude_2",
                     "exact coordinates-2" = "exact_coordinates_2",
                     "place ©-3" = "place_3",
                     "end location-3" = "end_location_3",
                     "latitude-3" = "latitude_3",
                     "longitude-3" = "longitude_3",
                     "exact coordinates-3" = "exact_coordinates_3",
                     "place (c)-4" = "place_4",
                     "end location-4" = "end_location_4",
                     "latitude-4" = "latitude_4",
                     "longitude-4" = "longitude_4",
                     "exact coordinates-4" = "exact_coordinates_4",
                     "place (c)-5" = "place_5",
                     "end location-5" = "end_location_5",
                     "latitude-5" = "latitude_5",
                     "longitude-5" = "longitude_5",
                     "exact coordinates-5" = "exact_coordinates_5",
                     "place (c)-6" = "place_6",
                     "end location-6" = "end_location_6",
                     "latitude-6" = "latitude_6",
                     "longitude-6" = "longitude_6",
                     "exact coordinates-6" = "exact_coordinates_6"
                   ))

# Transform variables
df <- transform(df,
                merged_id = as.integer(merged_id),
                start_date = as.Date(start_date, "%d/%m/%Y"),
                end_date = as.Date(end_date, "%d/%m/%Y"),
                minor = as.factor(minor),
                age = as.numeric(age),
                female = female - 1,
                violence = as.integer(violence),
                method = as.integer(method),
                number_previous_arrests = as.integer(number_previous_arrests),
                perpetrator_affiliation = as.integer(perpetrator_affiliation),
                place_1 = as.integer(place_1),
                exact_coordinates_1 = as.numeric(exact_coordinates_1),
                exact_coordinates_2 = as.numeric(exact_coordinates_2),
                exact_coordinates_3 = as.numeric(exact_coordinates_3),
                exact_coordinates_4 = as.numeric(exact_coordinates_4),
                exact_coordinates_5 = as.numeric(exact_coordinates_5)
)

# Recode torture and interrogation
df$torture <- ifelse(df$torture > 2 | is.na(df$torture), "NA",
                     ifelse(df$torture == 2, 0, df$torture))
df$interrogation <- ifelse(df$interrogation > 2 | is.na(df$interrogation), "NA",
                           ifelse(df$interrogation == 2, 0, df$interrogation))

# Revalue variables
df$minor <- plyr::revalue(df$minor, c("y" = 1, "n" = 0))

# Save data
readr::write_csv(df, "dataset.csv")

## Visualise Missing Data

# Proportion of variables that contain any missing values
miss_var_pct(df)

# Number of missings in each variable
gg_miss_var(df)

## Figure 1
df1 <- df %>%
        filter(!is.na(violence)) %>%
        group_by(violence) %>%
        summarise(n = n()) %>%
        mutate(freq = round(n / sum(n), 3)) %>%
        as.data.frame() %>%
        mutate(violence = factor(violence,
                                 labels = c("1" = "Killed",
                                            "2" = "Suicide",
                                            "3" = "Disappearance",
                                            "4" = "Disappearance\nwith Information",
                                            "5" = "Unresolved"))) %>%
        print()



ggplot(df1, aes(x = reorder(violence, -n), y = n)) +
        geom_histogram(stat = "identity") +
        scale_x_discrete("\nType of Violence") +
        geom_text(stat = "identity", aes(label = n),
                  vjust = -0.5, size = 2.6) +
        ylab("Number of Victims\n") +
        theme_minimal()  +
        theme(axis.text.y = element_blank(),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank())

## Figure 2
df2 <- df %>%
        select(age) %>%
        na.omit() %>%
        unlist() %>%
        as.numeric() %>%
        cut(breaks = c(0, 16, 20, 25, 30, 35, 40, 45, 50, 85)) %>%
        as.vector()

my_labels <- c("Under 16", "16-20", "20-25", "25-30", "30-35",
               "35-40", "40-45", "45-50", "Over 50")

ggplot(as.data.frame(df2), aes(x = df2)) +
        geom_histogram(stat = "count") +
        scale_x_discrete("", labels = my_labels) +
        geom_text(stat = "count", aes(label = ..count..),
                  vjust = -1, size = 2.6) +
        ylab("") +
        theme_minimal() +
        theme(axis.text.y = element_blank(),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank())

## Figure 3
df3 <- df %>%
        select(occupation) %>%
        filter(occupation %in% c(1:10)) %>%
        na.omit() %>%
        group_by(occupation) %>%
        summarise(n = n()) %>%
        mutate(freq = round(n / sum(n), 3)) %>%
        as.data.frame() %>%
        mutate(occupation = factor(occupation,
                                   labels = c("White\nCollar", "Blue\nCollar",
                                              "School\nStudent",
                                              "University\nStudent", "Military",
                                              "Non-Military\nGovernment",
                                              "Unemployed", "Unknown", "Ex-Military",
                                              "Housewife")))

ggplot(df3, aes(x = reorder(occupation, -n), y = n)) +
        geom_histogram(stat = "identity") +
        scale_x_discrete("") +
        geom_text(stat = "identity", aes(label = n),
                  vjust = -0.5,  size = 2.6) +
        ylab("") +
        theme_minimal() +
        theme(axis.text.y = element_blank(),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              axis.text.x = element_text(angle = 45, hjust = 1, size = 11))

## Tables 1, 2 and 3
df %>%
        select(interrogation) %>%
        group_by(interrogation) %>%
        summarise(n = n()) %>%
        mutate(freq = round(n / sum(n), 3))

df %>%
        select(torture) %>%
        group_by(torture) %>%
        summarise(n = n()) %>%
        mutate(freq = round(n / sum(n), 3))

df %>%
        select(targeted) %>%
        group_by(targeted) %>%
        summarise(n = n()) %>%
        mutate(freq = round(n / sum(n), 3))

## Figure 4
df5 <- df

df5$female <- factor(df5$female,
                     levels = c(0, 1),
                     labels = c("Male", "Female"))

df5$violence <- factor(df5$violence,
                       levels = c(1, 2, 3, 4, 5),
                       labels = c("1" = "Killed",
                                  "2" = "Suicide",
                                  "3" = "Disappearance",
                                  "4" = "Disappearance\nwith Information",
                                  "5" = "Unresolved"))

par(mar = c(0, 0, 0, 0))
mosaicplot(female ~ violence, data = df5, las = 1, color = TRUE,
           xlab = "Gender", main = "", ylab = "Type of Violence")

table(df5$violence, df5$female)

round(prop.table(table(df5$violence, df5$female)), 2)

## Figure 5
df4 <- df %>%
        select(violence, start_date) %>%
        na.omit() %>%
        mutate(violence_dummy = ifelse(violence >= 1, 1, 0)) %>%
        mutate(day = format(start_date, "%d"),
               month = format(start_date, "%m"),
               year = format(start_date, "%Y")) %>%
        filter(year < 1992 & year > 1972) %>%
        group_by(year, month) %>%
        summarise(total = sum(violence_dummy)) %>%
        mutate(dates = paste(month, year, sep="-")) %>%
        mutate(day = "01", date = paste0(day, "-", dates),
               date = lubridate::parse_date_time(date, "dmY"))

ggplot(df4, aes(date, total)) +
        geom_line() +
        scale_x_datetime(name = "",
                         date_breaks = "15 months",
                         expand = c(0, 0),
                         date_labels = "%b\n%Y") +
        ylab("") +
        theme_minimal(base_size = 12) +
        theme(panel.grid.minor = element_blank(),
              axis.text.x = element_text(hjust = 1))

## Figure 6
```{r}
df4 <- df %>%
        select(violence, start_date, occupation) %>%
        na.omit() %>%
        filter(occupation %in% c(1:6)) %>%
        mutate(violence_dummy = ifelse(violence >= 1, 1, 0)) %>%
        mutate(day = format(start_date, "%d"),
               month = format(start_date, "%m"),
               year = format(start_date, "%Y")) %>%
        filter(year < 1992 & year > 1972) %>%
        group_by(year, month, occupation) %>%
        summarise(total = sum(violence_dummy)) %>%
        mutate(dates = paste(month, year, sep="-")) %>%
        mutate(day = "01", date = paste0(day, "-", dates),
               date = lubridate::parse_date_time(date, "dmY")) %>%
        as.data.frame() %>%
        mutate(occupation = factor(occupation,
                                   labels = c("White\nCollar", "Blue\nCollar",
                                              "School\nStudent", "University\nStudent",
                                              "Military", "Non-Military\nGovernment")))

ggplot(df4, aes(date, total)) +
        geom_line() +
        scale_x_datetime(name = "",
                         date_breaks = "18 months",
                         expand = c(0, 0),
                         date_labels = "%b\n%Y") +
        ylab("") +
        theme_minimal(base_size = 12) +
        scale_y_continuous(expand = c(0, 0)) +
        theme(panel.grid.minor = element_blank(),
              axis.text.x = element_text(hjust = 1)) +
        facet_wrap( ~ occupation, scales = "free", ncol = 2)

## Figure 7
```{r, warning=FALSE,error=FALSE,message=FALSE,cache=TRUE, fig.width=11,fig.height=7}
df7 <- df %>%
        select(violence, longitude_1, latitude_1) %>%
        na.omit()

df7$violence <- factor(df7$violence,
                       levels = c(1, 2, 3, 4, 5),
                       labels = c("1" = "Killed",
                                  "2" = "Suicide",
                                  "3" = "Disappearance",
                                  "4" = "Disappearance\nwith Information",
                                  "5" = "Unresolved"))

sf_data <- rnaturalearth::ne_countries(returnclass = "sf", continent = c("South America", "North America"))

ggplot() +
        geom_sf(data = sf_data, colour = "black", size = .2, fill = "#eeeeee") +
        theme_minimal() +
        geom_point(data = df7, aes(x = longitude_1, y = latitude_1,
                                   color = factor(violence)),
                   alpha = 0.4, size = 1) +
        theme(axis.title.x = element_blank()) +
        theme(axis.title.y = element_blank()) +
        theme(legend.position = "none") +
        facet_wrap(~ violence, ncol = 3) +
        theme(plot.margin = unit(c(0, 0, 0.5, 0), "cm"))

## Figure 8
```{r, warning=FALSE,error=FALSE,message=FALSE,cache=TRUE,fig.width=11,fig.height=7}
df8 <- df %>%
        select(occupation, violence, longitude_1, latitude_1) %>%
        filter(occupation %in% c(1:10)) %>%
        na.omit() %>%
        group_by(occupation) %>%
        as.data.frame() %>%
        mutate(occupation = factor(occupation,
                                   labels = c("White\nCollar", "Blue\nCollar",
                                              "School\nStudent",
                                              "University\nStudent", "Military",
                                              "Non-Military\nGovernment",
                                              "Unemployed", "Unknown",
                                              "Ex-Military",
                                              "Housewife"))) %>%
        mutate(violence = ifelse(violence >= 1, 1, 0))

sf_data <- rnaturalearth::ne_countries(returnclass = "sf", continent = c("South America", "North America"))

ggplot() +
        geom_sf(data = sf_data, colour = "black", size = .2, fill = "#eeeeee") +
        theme_minimal() +
        geom_point(data = df8, aes(x = longitude_1, y = latitude_1,
                                   color = factor(occupation)),
                   alpha = 0.4, size = .8) +
        theme(axis.title.x = element_blank()) +
        theme(axis.title.y = element_blank()) +
        theme(legend.position = "none") +
        facet_wrap(~ occupation, ncol = 4) +
        theme(plot.margin = unit(c(0, 0, 0.5, 0), "cm"))
