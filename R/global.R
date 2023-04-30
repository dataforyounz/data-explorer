library( shiny )
library( shinydashboard )
library( shinydashboardPlus )
library( skimr )
library( kableExtra )
library( tidyverse )

# Only want data frames

datasets <- ls("package:datasets")
data     <- lapply(datasets, get, "package:datasets")
names    <- names[vapply(data, is.data.frame, logical(1))]

