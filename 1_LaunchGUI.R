

#remove.packages("forecastR")
#install.packages("devtools") # Install the devtools package
library(devtools) # Load the devtools package.
install_github("SOLV-Code/forecastR_package")

library(tidyverse)

source("App Files/R/3c_HelperFunctions_ModelSetup.R")
source.modules("App Files/R/")

#Then open server.R and click "Run App"



#---------------------------------



# Load the function that does the model set-up and launches the GUI
source("../LaunchFunction.R")

# testing the files
#sink("test.txt")
#parse("App Files/server.R")
#sink()

#sink("test.txt")
#parse("App Files/ui.R")
#sink()


# Run the function to launch locally
launchForecastR(appDir.use="App Files",local=TRUE)



# go to last deployed server version
launchForecastR(local=FALSE)







