library(reshape2)
library(plyr)
library(stringr)

# https://vimeo.com/33727555

pew <- read.delim(
  file = "http://stat405.had.co.nz/data/pew.txt",
  header = TRUE,
  stringsAsFactors = FALSE,
  check.names = F
)

tidy <- melt(pew, "religion")
names(tidy) <- c("religion", "income", "n")


tb <- read.csv(
  file = "https://raw.githubusercontent.com/hadley/tidyr/master/vignettes/tb.csv",
  header = TRUE, 
  stringsAsFactors = FALSE
)

tidy_2 <- melt(tb, id= c("iso2", "year"), na.rm = TRUE)
names(tidy_2)[4] <- "cases"
tidy_3 <- arrange(tidy_2, iso2, variable, year)

str_sub(tidy_3$variable, 1 , 1)
str_sub(tidy_3$variable, 2)

ages <- c("04" = "0-4", "514" = "5-14", "014" = "0-14", "1524"="15-24", "2534"="25-34",
          "3544"="35-44", "4554"="45-54", "5564"="55-64", "65"="65+", "u"=NA)

ages[str_sub(tidy_3$variable, 2)]

tidy_3$sex <- str_sub(tidy_3$variable, 1 , 1)
tidy_3$age <- factor(ages[str_sub(tidy_3$variable, 2)], levels = ages)

tidy_3$variable <- NULL

tidy_3 <- tidy_3[c("iso2", "year", "sex", "age", "cases")]

#### Variables in rows and columns  ####

weather <- read.delim(
  file = "http://stat405.had.co.nz/data/weather.txt",
  stringsAsFactors = FALSE
)

raw1 <- melt(weather, id = 1:4, na.rm=T)
raw1$day <- as.integer(
  str_replace(raw1$variable, "d", "")
)
raw1$variable <- NULL
raw1$element <- tolower(raw1$element)
raw1 <- raw1[c("id", "year", "month", "day", "element", "value")]
raw1 <- arrange(raw1, year, month, day, element)

tidy <- dcast(raw1, ... ~ element)

#### Tidy tool ####  min 29:20
