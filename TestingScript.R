
library(tidyverse)

source("App Files/R/3c_HelperFunctions_ModelSetup.R")
source.modules("App Files/R/")


#test.data <- read.csv("SampleData/Atnarko_Ch_Esc_to2019_3_6_ForecastR_RR.csv")
#test.data <- read.csv("SampleData/Atnarko_Ch_Esc_to2019_3_6_ForecastR.csv")
#test.data <- read.csv("SampleData/FinalSampleFile_WithAge_exclTotal_covariates_TEST.csv")
#test.data <- read.csv("SampleData/TEST_Atnarko_Ch_Esc_to2020_3_6_ForecastR_for testing only.csv")
#test.data <- read.csv("SampleData/TEST2_Alsea forecastR work 1 covariate SRH survival.csv")
test.data <- read.csv("SampleData/NBC_Esc_No_Age_upto2020.csv")




test.data.prepped <- prepData(test.data,out.labels="v2")
names(test.data.prepped)
test.data.prepped$data
test.data.prepped$covariates
test.data.prepped$predictors

test.data.prepped$sibreg.in


source.modules("App Files/R/")
createBootsSibReg(data.sibreg = test.data.prepped$sibreg.in,
															boot.n=10, plot.diagnostics=TRUE)




#############
# complex subset issue

test.data.prepped$data[["Age 6"]] %>% left_join(test.data.prepped$data[["Age 5"]] %>%
																	 	select(Brood_Year,all_of("Age_5")), by= "Brood_Year")










####################


# bootstrap issue


booted.data <- createBoots(dat.prepped = test.data.prepped,
													 boot.type= "meboot",
													 boot.n=10,
													 plot.diagnostics=TRUE
													 )
head(booted.data[[1]]$'Age 5')
head(booted.data[[2]]$'Age 5')




# retrospective issue
# fixed with https://github.com/SOLV-Code/forecastR-ServerApp/pull/45

yrs.data <- test.data.prepped$data$`Age 3`$Run_Year
yrs.retro.tmp <- (min(yrs.data)+20):max(yrs.data)
yrs.retro.tmp

data.extract(data = test.data.prepped$data ,yrs = yrs.retro.tmp,option="obs" )


data.extract(data = test.data.prepped$data ,yrs = 2016,option="retro" )


######################################


X <- test.data.prepped$data$`Age 5`
covars.list <- names(X)[grepl("Cov_",names(X))]

covars.list[1]

combn(covars.list[1],2) %>% apply(MARGIN = 2, paste,collapse = " + ")

combn(covars.list[1],3) %>% apply(MARGIN = 2, paste,collapse = " + ") # triples

paste("( ", combn(covars.list,3) %>% apply(MARGIN = 2, paste,collapse = " + ")," )^2")


