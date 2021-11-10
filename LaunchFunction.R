# THIS DEFINES THE FUNCTION THAT LAUNCHES THE GUI IN A BROWSER
# The actual GUI lives in ui.R.
# The function call using the GUI output as an input lives in server.R





launchForecastR <- function(appDir.use=NULL,local=TRUE){

# just keeping this around for consistency with earlier scripts
# and as a placholder for potential future steps.

if(!local){browseURL("https://solv-code.shinyapps.io/forecastr/")}

if(local){

library(shiny)

# don't need the function sourcing anymore (b/c get 'em from Package repo)
# don't need the java check anymore (b/c using markdown and render)

if(is.null(appDir.use)){appDir.use <- "../inst/forecastR"}

# run the app
runApp(appDir = appDir.use)




}


} # end function launchForecastR 






####################################################################


launchForecastR_OLD <- function(appDir.use=NULL,fun.path=NULL,local=TRUE){

if(!local){browseURL("https://solv-code.shinyapps.io/forecastr/")}

if(local){

# read in all ".R" files and ".r" files in /R, and all files with "_functions.r" from the subfolders"
# -------------------

if(is.null(fun.path)){fun.path <- "../R"}

for(dir.use in list.dirs(path=fun.path,full.names = TRUE, recursive = TRUE)){
	print("------------------")
	print(dir.use)
	
	if(dir.use == fun.path){pattern.list <- c("*[.]R$","*[.]r$") } 
	if(dir.use != fun.path){pattern.list <- c("_functions.R","_functions.r") } 	

	
	
	for(pattern.use in pattern.list){
		print("----------")
		print(pattern.use)
		fn.file.list <- list.files(path=dir.use,pattern=pattern.use) # get all .R files 
		print(fn.file.list)
		print("-------")
		for(file.source in fn.file.list){
			print(paste("Sourcing: ",file.source))
			source(paste(dir.use,file.source,sep="/"))
			} # end looping through files
		} # end looping through patterns
	} # end looping through folders


# run the Java version check, and do the rest only if have matching Java/R versions (32 vs 64 bit)
java.match <- checkJava()

# launch GUI only if set-up matches
if(java.match){


# load/install packages needed to run the reports
# trying to keep roughly the loading sequence from the "WithAge" Report
# There are several "masking object X from package Y" warnings produced by this
load_or_install(c("rlang","stringr","ReporteRs",
				"AICcmodavg","BBmisc","nlme","meboot","zoo",
				"formula.tools","scales","grid","gridExtra",
				"boot","plyr","rlist","forecast","dynlm",
				"GGally","portes","ggplot2","dplyr",
				"magrittr","MASS","data.table",
				"scatterplot3d","ucminf","survey","estimability",
				"poLCA","heplots","ordinal","effects", "calibrate","reshape",
				"chron","rJava","stringr"
				))

				
# load/install packages for report generation
load_or_install("devtools")
load_or_install("rJava")
#devtools::install_github('davidgohel/ReporteRsjars')
#devtools::install_github('davidgohel/ReporteRs')

# load/install functions needed for shiny dashboard
# testing "shinyFiles" for report destination via  shinyDirButton()
load_or_install(c("shiny","shinydashboard","shinyjqui","shinyFiles","shinydashboard","ggplot2","DT","markdown"))


if(is.null(appDir.use)){appDir.use <- "../inst/forecastR"}

# run the app
runApp(appDir = appDir.use)
} # end launching GUI if set-up matches

# launch GUI only if set-up matches
if(!java.match){stop("Java and R version mismatch (32vs64bit)")}

}


} # end function launchForecastR 



