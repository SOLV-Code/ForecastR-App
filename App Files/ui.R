

# Think it needs these here for the server deployment
# shiny deployment looks for library(), so need that too in order to get the dependencies)
source("R/3c_HelperFunctions_ModelSetup.R")
source.modules("R/")
load_or_install(c("ggplot2","DT","markdown","rmarkdown","shiny","shinydashboard","shinyjqui","shinyFiles"))
library("ggplot2")
library("DT")
library("markdown")
library("rmarkdown")
library("shiny")
library("shinydashboard")
library("shinyjqui")
library("shinyFiles")
library("shinybusy")
library("shinyBS")




# TEMPORARY: NEED THIS HERE UNTIL MODEL SELECTION IS SWITCHED TO DYNAMIC FOR ALL TABS
model.types <- list("Naive" = "Naive", "Time Series" = c("TimeSeriesArima","TimeSeriesExpSmooth"),
										"Sibling" = c("SibRegSimple","SibRegLogPower", "SibRegKalman","SibRegComplex"),
										"ReturnRate"="ReturnRate","NoAgeCovar"="NoAgeCovar")



# for reports using old code OBSOLETE
#fc.model.list.withage <-  c("n1.model","n3.model","n5.model","ARIMA.model","EXPSMOOTH.model",
#						"SIMPLESIBREG.model","SIMPLELOGPOWER.model")
#fc.model.list.withoutage <- c("noagemodelnaiveone","noagemodelavgthree","noagemodelavgfive",
#								"noagemodelarima","noagemodelexpsmooth")





# TEMPORARY: NEED THIS HERE UNTIL AGE SELECTION IS SWITCHED TO DYNAMIC FOR ALL TABS
# This is a kludge, until can dynamically link the dropdown and the tabset to the ages in the input file
#ages.menu.list <- c("First","Second","Third","Fourth","Fifth","Sixth","Seventh","Eighth")
ages.menu.list <- c("all","Age 2","Age 3","Age 4","Age 5","Age 6","Age 7")
ages.menu.list.multi <- c("Total","Age 2","Age 3","Age 4","Age 5","Age 6","Age 7")




# OLD
#retro.types <- c("retro.pm.bal", "retro.pm.all.constantyrs", "retro.pm.all.varyrs","fitted.pm.last")
#names(retro.types) <- c("Balanced","Constant Years","Variable Years","Fitted")
retro.types <- list("Retrospective" = c("Balanced" = "retro.pm.bal", "Constant Years" = "retro.pm.all.constantyrs",
																				"Variable Years" = "retro.pm.all.varyrs"),
										"Model Residuals" =c("Fitted" = "fitted.pm.last"))




boots.method.list <-  c("meboot", "stlboot") #meboot = max entropy, stlboot = loess")

report.type.list <- c("Pdf - Key Plots Only","Pdf - Long","Word - Short","Word - Long")

navbarPage("ForecastR", id = "MainTab",

           
# First Panel
           

	 tabPanel("Info/Help",

tabsetPanel(type = "tabs", 
	                      
tabPanel("Disclaimer", 
  fluidRow(
    column(8,
	  includeMarkdown("Markdown/disclaimer.md")
    ))),	  # end disclaimer

tabPanel("Help",
    fluidRow(
             column(8,
                    includeMarkdown("Markdown/help.md")
             ))),	  # end help

tabPanel("About",
           fluidRow(
             column(8,
                    includeMarkdown("Markdown/about.md")
             )))	  # end About
) # end tabsetpanel
),  # end Help/Info tab panel




#######
          
tabPanel("Setting Up", value= "setting.up",
         
tabsetPanel(type = "tabs", 

tabPanel("Data Loading", value = "data.loading",
      
         fluidRow(column(10, div(style="display: inline-block;", tags$h4("Data Source")),
                         div(style="display: inline-block;",
                             bsButton(inputId = "data_loading_help", label="?",  size = "extra-small",
                                      style = "primary", type= "action"),
                             bsPopover("data_loading_help", title = "Data Sources", content = 
                                         paste("You can select one of the sample data files",
                                               "or load your own csv file. Sample data files",
                                               "either have age-specific data or not,",
                                               "and either have covariates or not. You can download",
                                               "a sample data file by clicking csv after selecting it.",
                                               "The quickest way to create your own input files is",
                                               "to download a sample file with the same data structure and",
                                               "then populate that."
                                               ),
                                       "bottom", trigger = "click"))
         )),   
         
              
      fluidRow(column(10,
                         div(style="display: inline-block;",
                             selectizeInput("data.source", "Select Data Source", choices = c("My File","Sample 1 - Ages With Covariates",
                                                                                             "Sample 2 - No Ages with Covariates",
                                                                                             "Sample 3 - Ages, No Covariates",
                                                                                             "Sample 4 - No Ages, No Covariates"
                                                                                                                                                                                          ), selected="File")))),   
         
      fluidRow(column(10,
                      div(style="display: inline-block;",
                          fileInput("file.name.2", "Choose CSV File (if selecting  'My File' above)", 
                                    accept = c("text/csv","text/comma-separated-values,text/plain", ".csv"))
                          ,
                          #tags$a("Get Some Sample Data",
                          #href="https://www.dropbox.com/sh/7pdqfmvn16v59uk/AAB52T_T8ItI0uEsjyk6PVXxa?dl=0",
                          #target="_blank")
                          )
      )),                               
      hr(),                       
      div(style = "height:500px; overflow-y: scroll;overflow-x: scroll;",
          	# OLD			tableOutput("inputheader.table"),
          DT::dataTableOutput("inputheader.table"),
          height = "400px",width = "200px")
  ),

#######
tabPanel("Display Settings", value= "display.settings",
         fluidRow(column(10, div(style="display: inline-block;", tags$h4("All Models")),
                            div(style="display: inline-block;",
                            bsButton(inputId = "display_settings_help", label="?",  size = "extra-small",
                                           style = "primary", type= "action"),
                             bsPopover("display_settings_help", title = "Settings Used Throughout the App", content = 
                                         paste("FORECASTED VARIABLE is the label used in plots and tables.",
                                               "This does not affect any calculations.",
                                               "Default value is the generic Abundance.",
                                               "A common alternative is Terminal Run.",
                                               "MODEL EQUATIONS can be displayed in result plots or not, depending on the target audience.",
                                               "NUMBER OF DECIMALS determines the digits after 0 shown in tables. Default is 0, because the response variable in",
                                               "Chinook salmon forecasting data sets is typically in number of fish."
                                               ),
                                       "bottom", trigger = "click"))
         )),
         
         textInput("axis_label", label=h5("Label for Forecasted Variable"), value = "Abundance", width = "40%") #,
        # checkboxInput("show.equ","Show model details in figures (equation for complex sibreg, type for time series models, not linked yet)",value=FALSE),
        # numericInput("table_decimals", label=h5("Number of decimals shown in tables and figures (NOT YET LINKED)"),
        #              value = 0 , min = 0, max = 10, step = 1,   width = "40%")
), # end  display settings panel

tabPanel("Data Treatment Settings", value= "data.treatment.settings",  
        fluidRow(column(10, div(style="display: inline-block;",tags$h4("Covariate Models: Complex Sibling Regressions, NoAge Covar")),
            div(style="display: inline-block;",
                            bsButton(inputId = "covar_rescale_help", label="?",  size = "extra-small",
                                     style = "primary", type= "action"),
                            bsPopover("covar_rescale_help", title = "Data Treatment for Covariate Models", content = 
                                        paste("insert some text to explain how these models use covariates",
                                              ", how the covariate rescaling works, and why the default is TRUE.",
                                              "Can also include links",a("like this", 
                                                                         href = "https://academic.oup.com/icesjms/article/79/4/1259/6567589",
                                                                         target="_blank"),"."),
                                      "bottom", trigger = "click")),        
                                )),
                                
         checkboxInput("cov_rescale", label="Rescale Covariates?", value = TRUE )
                        
        #fluidRow(column(12, div(style="display: inline-block;",
        #      
        #div(style="display:inline-block;width:30%;text-align: left;",
        #    ),
        
) # end  data treatment settings panel
) # end tabset panel	
),  # end  second tab panel



#################### MODEL PRE CHECK ######################################


    tabPanel("Explore FC", value= "precheck",

             
	pageWithSidebar(
	headerPanel("Explore Models"),

	sidebarPanel(width = 3,
	  add_busy_spinner(spin = "fading-circle", position = "full-page"),
	  
	  fluidRow(div(style="display: inline-block;", tags$h3("Model Options")),
	                  div(style="display: inline-block;",
	                      bsButton(inputId = "precheck_model_selection_help", label="?",  size = "extra-small",
	                               style = "primary", type= "action"),
	                      bsPopover("precheck_model_selection_help", title = "Model Types", content = 
	                                  paste("START (Run Year): data subsettig, any records before start year will be exluded. MODEL TYPE: Select a type of forecasting model.",
	                                  "Available models are determined based on the input data.",
	                                  "Model-specific settings will show up below.",
	                                  "For an overview of model types and their data requirements, refer to the",
	                                  a("Model Types Wiki Page",
	                                    href = "https://github.com/SalmonForecastR/ForecastR-Releases/wiki/5-Forecast-Models#model-types", target="_blank"),"."),
	                                "bottom", trigger = "click"))
	  ),
	  #numericInput("fc.yr", "FC Year", value=2018),  # comes from data file for now
	  # slider below is for now changed to only give start year, then add the end year as 1-fc.yr on the server side
	  sliderInput("yr.range.precheck", "Start (Run Years)",sep="",min = 1960, max = 2020, value = 1975,animate=TRUE),
	  #tags$hr(style = "border-top: 1px solid #000000;"),	  
		uiOutput("model_menu_precheck"),  # MODEL SELECTION HAPPENS HERE
		conditionalPanel(condition = "input['model_use_precheck'] == 'ReturnRate'",
		                          
		                 fluidRow(div(style="display: inline-block;", tags$h4("Return Rate Model")),
		                          div(style="display: inline-block;",
		                              bsButton(inputId = "precheck_rate_help", label="?",  size = "extra-small",
		                                            style = "primary", type= "action"),
		                                 bsPopover("precheck_rate_help", title = "Return Rate Model Settings", content = 
		                                             paste( "PREDICTOR VARIABLE: Candidate variables are determined from the data set, if available.",
		                                                    "AVG:", "Return rate models use observed average. Choose the type of average here.",
		                                                    "wtmean = weighted arithmentic mean, mean = arithmetic mean, median = median.",
		                                                    "LAST N OBS: Use the last n observations to calculate the rate",
		                                                    a("Return Rate Models Wiki Page",
		                                                      href = "https://github.com/SalmonForecastR/ForecastR-Releases/wiki/5-Forecast-Models#return-rate-mechanistic-models", target="_blank"),"."),
		                                           "bottom", trigger = "click"))
		                 ),
		                fluidRow(column(1),column(8,uiOutput("pred_var_precheck_menu"))),
		                fluidRow(column(1),
		                         column(4,selectizeInput("rate_avg_precheck", "Avg", 
		                             choices = c("wtmean","mean", "median"), selected="wtmean")),
		                          column(4,numericInput("last_n_precheck", "Last n obs",  
		                            value = 100 , min = 1, max = 100, step = 1)) #,  width = "100%"))		                 
		                     )
		                 
		), # end conditional panel for return rate
		conditionalPanel(condition = "input['model_use_precheck'] == 'TimeSeriesArima' || input['model_use_precheck'] == 'TimeSeriesExpSmooth'",
						fluidRow(div(style="display: inline-block;", tags$h4("Time Series Models")),
		                          div(style="display: inline-block;",
		                              bsButton(inputId = "precheck_timeseries_help", label="?",  size = "extra-small",
		                                       style = "primary", type= "action"),
		                              bsPopover("precheck_timeseries_help", title = "Time Series Model Settings", content = 
		                                              paste("BOX-COX TRANSFORM: If selected, data is converted to a more normal distribution of the variance.",
                                                   "For an overview of time series models, including an explanation of the Box-Cox transformation, refer to the",
                                                   a("Time Series Models Wiki Page",href = "https://github.com/SalmonForecastR/ForecastR-Releases/wiki/5-Forecast-Models#time-series-models", target="_blank"),".")
                                                   ,
		                                          "bottom", trigger = "click"),
		                              )
		                 ),           
		                 
		                 
		                 
		                 uiOutput("boxcox.precheck.menu")
		),
		conditionalPanel(condition = "input['model_use_precheck'] == 'SibRegKalman'",
		                 fluidRow(div(style="display: inline-block;", tags$h4("Kalman SibReg Models")),
		                          div(style="display: inline-block;",
		                              bsButton(inputId = "precheck_sibreg_kalman_help", label="?",  size = "extra-small",
		                                       style = "primary", type= "action"),
		                              bsPopover("precheck_sibreg_kalman_help", title = "Kalman SibReg Model Settings", content = 
		                                          paste("AVG N EST: NEED MORE TEXT.",
		                                                "For an overview of Sibling Regression models with time-varying parameters, refer to the",
		                                                a("Kalman Filter SibReg Wiki Page",
		                                                  href = "https://github.com/SalmonForecastR/ForecastR-Releases/wiki/5-Forecast-Models#sibling-regressions-with-time-varying-parameters-kalman-filter", target="_blank"),"."),
		                                        "bottom", trigger = "click"))
		                 ),             
		              uiOutput("intavg.precheck.menu")
		),
		conditionalPanel(condition = "input['model_use_precheck'] == 'SibRegComplex'",
		                 # This has the same structure is NoAgeCovar menu (Any fixes need to implemented for both)
									 fluidRow(div(style="display: inline-block;", tags$h4("Complex SibReg Models")),
									 div(style="display: inline-block;", 
										              bsButton(inputId = "precheck_sibreg_complex_help", label="?",  size = "extra-small",
										                       style = "primary", type= "action")),
									         bsPopover("precheck_sibreg_complex_help", title = "Complex SibReg Model Settings", content = 
										                          paste("insert some text to explain how AIC and R²",
										                                "are used to select among candidate models by age class"),
										                        "bottom", trigger = "click")
										 ),             
	          fluidRow(column(1),
	         column(5,uiOutput("complex.precheck.menu1")),
	         column(5,uiOutput("complex.precheck.menu2"))   )
										 #div(style="display:inline-block;width:80%;text-align: center;",uiOutput("complex.precheck.menu1")),
										 #div(style="display:inline-block;width:80%;text-align: center;",uiOutput("complex.precheck.menu2"))
										  
		),
		conditionalPanel(condition = "input['model_use_precheck'] == 'SibRegPooledSimple' || input['model_use_precheck'] == 'SibRegPooledLogPower'",
		                 fluidRow(div(style="display: inline-block;", tags$h4("Pooled SibReg Models")),
		                          div(style="display: inline-block;",
		                              bsButton(inputId = "precheck_sibreg_pooled_help", label="?",  size = "extra-small",
		                                       style = "primary", type= "action"),
		                              bsPopover("precheck_sibreg_pooled_help", title = "Pooled SibReg Model Settings", content = 
		                                          paste("MAX POOL: Maximum number of cohorts to pool for the model fit. NEED MORE TEXT."),
		                                        "bottom", trigger = "click"))
		                 ),
		                 uiOutput("max.pool.precheck.menu")
		),
		conditionalPanel(condition = "input['model_use_precheck'] == 'Naive'",
		                 
		                 fluidRow(div(style="display: inline-block;", tags$h4("Naive Model")),
		                          div(style="display: inline-block;",
		                              bsButton(inputId = "precheck_naive_help", label="?",  size = "extra-small",
		                                       style = "primary", type= "action"),
		                              bsPopover("precheck_naive_help", title = "Naive Model Settings", content = 
		                                          paste("AVG YEARS: Number of years used for the average.",
                                                    a("Naive Models Wiki Page",
                                                      href = "https://github.com/SalmonForecastR/ForecastR-Releases/wiki/5-Forecast-Models#naive-models", target="_blank"),"."),       
		                                            "bottom", trigger = "click"))
		                 ),
										 uiOutput("avgyrs_precheck_menu")
										 ),
		conditionalPanel(condition = "input['model_use_precheck'] == 'NoAgeCovar'",  
		                 # This has the same structure is Complex Sibreg menu (Any fixes need to implemented for both)
		                 fluidRow(div(style="display: inline-block;", tags$h4("NoAge Covar Models")),
		                          div(style="display: inline-block;", 
		                              bsButton(inputId = "precheck_noagecovar_help", label="?",  size = "extra-small",
		                                       style = "primary", type= "action")),
		                          bsPopover("precheck_noagecovar_help", title = "NoAge Covar Model Settings", content = 
		                                      paste("insert some text to explain how AIC and R²",
		                                            "are used to select among candidate models"),
		                                    "bottom", trigger = "click")
		                 ),             
		                 fluidRow(column(1),
		                          column(5,uiOutput("noagecovar.precheck.menu1")),
		                          column(5,uiOutput("noagecovar.precheck.menu2"))   )
		                 #div(style="display:inline-block;width:80%;text-align: center;",uiOutput("complex.precheck.menu1")),
		                 #div(style="display:inline-block;width:80%;text-align: center;",uiOutput("complex.precheck.menu2"))
		                 
		),
		tags$hr(style = "border-top: 1px solid #000000;"),
		fluidRow(div(style="display: inline-block;", tags$h3("Forecast Intervals")),
		         div(style="display: inline-block;",
		             bsButton(inputId = "precheck_interval_help", label="?",  size = "extra-small",
		                      style = "primary", type= "action"),
		             bsPopover("precheck_interval_help", title = "Forecast Intervals", content = 
		                         paste("Three types of interval are currently available. RETROSPECTIVE uses the distribution or errors from a retrospective test",
		                         "with a specified mimimum number of observations (i.e. need at least x obs for the first year of the retrospective).",
		                         "Note that the retrospective interval may be inappropriate for short time series (few values to generate interval) and will cause an error if selected value",
		                         "exceeds (years - 1) for the oldest age class",
		                         "PREDICTION uses the standard deviation of residuals from the model fit.",
		                         "BOOTSTRAP resamples the data and restimates the forecast for each of n resampled data set"),
		                       "bottom", trigger = "click"))
		),
		fluidRow(column(1),
		         column(5,selectizeInput("interval.type.precheck", "Interval Type", choices = c("Retrospective","Prediction","Bootstrap"), selected="Retrospective")),
		         ),
		conditionalPanel(condition = "input['interval.type.precheck'] == 'Retrospective'",
		                 fluidRow(column(1),
		                          column(10,sliderInput("min.retroyrs.explore", "Min Yrs for Retro", sep="",min = 10, max = 35, value = 15,animate=FALSE))
		                 )),	
		conditionalPanel(condition = "input['interval.type.precheck'] == 'Bootstrap'",
		                 fluidRow(column(1),
		                 column(4,numericInput("boot.n.precheck", "Sample",  value = 100 , min = 10, max = 1000, step = 10,   width = "100%")),
		                 column(5,selectizeInput("boot.type.precheck", "Type", choices = c("meboot","stlboot"), selected="meboot"))
		)),
		conditionalPanel(condition = "input['interval.type.precheck'] == 'Prediction' & input['model_use_precheck'] == 'NoAgeCovar'",  
		                 fluidRow(div(style="display: inline-block; color: red", tags$i("NOTE: Prediction intervals for NoAge Covar Models are unrealistically narrow at the moment. 
		                                                                      Calculations and code implementation are under review. For now, use one of the other intervals for this model.")) )),
		
		
		
		fluidRow(column(12,tags$hr(style = "border-top: 1px solid #000000;"))),
		fluidRow(column(1),
		         column(5,downloadButton("downloadPreCheckRep", "Download PDf report"))  ),
		
		#conditionalPanel(condition = "input.explore.diagnostics == 'FitsPointFC' || input.explore.diagnostics == 'Diagnostics'",
		                 tags$hr(style = "border-top: 1px solid #000000;"),
		                 fluidRow(column(1),
		                          column(5,uiOutput("ages.menu.precheck"))
		#)
		)


		) # end sidebar
  ,


     mainPanel(width = 9,


		 tabsetPanel(id = "explore.diagnostics",
		             type = "tabs",
          tabPanel("Fits & Point Forecast", value = "FitsPointFC", plotOutput("precheck.plot.fitandfc",width = "100%", height = "600px")),
				  tabPanel("Forecast Plot", value = "FCPlot",plotOutput("precheck.plot.intervals",width = "100%", height = "600px")),
				  tabPanel("Forecast Table",  value = "FCTable", DT::dataTableOutput("table.explore.fc")#,
							#downloadButton("download.table.explore.fc","Download")
							),
				tabPanel("Diagnostics", value = "Diagnostics",
				tabsetPanel(id = "DiagnosticsSub",
				            type = "tabs",
				  tabPanel("Obs vs. Fitted",plotOutput("precheck.plot.fitvsobs",width = "100%", height = "600px") ),
				  tabPanel("Residual vs. Fitted",plotOutput("precheck.plot.residvsfitted",width = "100%", height = "600px") ),
				  tabPanel("Residual Pattern",plotOutput("precheck.plot.resid_ts",width = "100%", height = "600px") ),
          tabPanel("Residual Histogram",plotOutput("precheck.plot.resid_hist",width = "100%", height = "600px") ),
				  tabPanel("Residual QQ Norm",plotOutput("precheck.plot.resid_qq",width = "100%", height = "600px") ),
				  tabPanel("Kalman Diagnostic",
				  				 h4("Only applicable for Model type = SibRegKalman" , align = "left"),
				  				 plotOutput("precheck.modeldiagnostic",width = "100%", height = "600px") ),
				  tabPanel("Covar Model Diagnostic",
								h4("Only applicable for models with covariates" , align = "left"),
				  						 				 uiOutput("ages.menu.model.selection"),
				  						 				 DT::dataTableOutput("table.explore.model.selection")#,
				  								 				# downloadButton("download.explore.model.selection","Download")
				  						 				 ),
				  tabPanel("Bootstrapped Series",value = "Bootstrapped Series", plotOutput("precheck.plot.boots.sample",width = "100%", height = "600px") )
				  	))
  				  
				  )




		) # end main panel

		) #end page with side bar for model pre-check



	),






####################################



	 tabPanel("Compare FC" , value= "compare",

	pageWithSidebar(
	headerPanel("Compare Models"),

	sidebarPanel(width = 3,

		# https://stackoverflow.com/questions/43973863/keep-datatable-sort-between-tabs-in-shiny
		# try to link table sorting to the plot order

		#actionButton("addmodel.compare", "x Add a Model"),
		#actionButton("resetmodel.compare", "x Reset Models"),
		add_busy_spinner(spin = "fading-circle"),
		tags$p("Note: Running a new batch of models takes a little time"),
		selectizeInput("retrotype.compare", "Performance Measure Type", choices = retro.types, selected=retro.types[1]),
		selectizeInput("interval.type.compare", "Interval Type", choices = c("Retrospective","Prediction","Bootstrap"), selected="Retrospective"),
		numericInput("boot.n.compare", "Interval Sample",  value = 100 , min = 10, max = 1000, step = 10,   width = "50%"),
		selectizeInput("boot.type.compare", "Bootstrap Type", choices = c("meboot","stlboot"), selected="meboot"),
		#numericInput("fc.yr", "FC Year", value=2018),  # comes from data file for now
		# slider below is for now changed to only give start year, then add the end year as 1-fc.yr on the server side
		sliderInput("yr.range.compare", "Start (Run Years)", sep="",min = 1960, max = 2020, value = 1975,animate=FALSE),
		sliderInput("min.retroyrs.compare", "Min Yrs for Retro", sep="",min = 10, max = 35, value = 15,animate=FALSE),
		checkboxGroupInput("compare.pm", label="Perf. Measures for Model Ranking",
				choices=c("MRE","MAE","MPE","MAPE","MASE","RMSE")   ,
					selected = c("MRE","MAE","MPE","MAPE","MASE","RMSE") , inline = TRUE),
		checkboxInput("rel.bol","Use Scaled Ranking",value=FALSE)
		#downloadButton("downloadComparisonTxt", "x Download text file"),
		#downloadButton("downloadComparisonCsv", "x Download csv files"),
		#downloadButton("downloadComparisonRep", "x Download pdf report"),

		#actionButton("create.precheck.summary.withoutage", "Create PDF Report")



		) # end sidebar
  ,


     mainPanel(id = "CompareMain",


		 tabsetPanel(type = "tabs",

				  tabPanel("Settings",
							tabsetPanel( id = "CompareModelSettings",type = "tabs",
								tabPanel("N1",
												 tags$h4("Naive Model"),
												 tags$h5("All Data Types"),
												checkboxInput("m1.use","Include this model",value=TRUE),
											  textInput("m1.name", "Model Label", value = "Naive3", width = "40%"),
											  selectizeInput("m1.modeltype", "Model Type", choices = "Naive", selected="Naive", width = "40%"),
											  numericInput("m1.avgyrs", label=h5("Avg Years (Naive Models)"), value = 3 , min = 1, max = 10, step = 1,   width = "40%"),
												#),
												#column(6,
												# checkboxInput("m1.boxcox","Box-Cox Transf. - Time Series Models",value=FALSE),
											 # numericInput("m1.kfyear", label=h5("Avg Years for time-varying par (Kalman Filter Models)"), value = NULL , min = 1, max = 50, step = 1,   width = "40%")
											  #)
												)	,
								tabPanel("N2",
												 tags$h4("Naive Model"),
												 tags$h5("All Data Types"),
												 checkboxInput("m2.use","Include this model",value=TRUE),
											  textInput("m2.name", "Model Label", value = "Naive5", width = "40%"),
											  selectizeInput("m2.modeltype", "Model Type", choices = "Naive", selected=model.types[1], width = "40%"),
											  numericInput("m2.avgyrs", label=h5("Avg Years (Naive Models)"), value = 5 , min = 1, max = 10, step = 1,   width = "40%"),
											  #checkboxInput("m2.boxcox","Box-Cox Transf. - Time Series Models",value=FALSE),
											  #numericInput("m2.kfyear", label=h5("Avg Years for time-varying par (Kalman Filter Models)"), value = NULL , min = 1, max = 50, step = 1,   width = "40%")
											  ),
		
								
							tabPanel("TS1",
												 tags$h4("Time Series Model"),
												 tags$h5("All Data Types"),
												 checkboxInput("m6.use","Include this model",value=TRUE),
												 textInput("m6.name", "Model Label", value = "TSArimaBC", width = "40%"),
												 selectizeInput("m6.modeltype", "Model Type", choices = c("TimeSeriesArima","TimeSeriesExpSmooth"), selected="TimeSeriesArima", width = "40%"),
												 #numericInput("m6.avgyrs", label=h5("Avg Years (Naive Models)"), value = NULL , min = 1, max = 10, step = 1,   width = "40%"),
												 checkboxInput("m6.boxcox","Box-Cox Transf. - Time Series Models",value=TRUE)#,
												 #numericInput("m6.kfyear", label=h5("Avg Years for time-varying par (Kalman Filter Models)"), value = NULL, min = 1, max = 50, step = 1,   width = "40%")
								),
								tabPanel("TS2",
												 tags$h4("Time Series Model"),
												 tags$h5("All Data Types"),
													checkboxInput("m7.use","Include this model",value=TRUE),
												 textInput("m7.name", "Model Label", value = "TSArimaNoBC", width = "40%"),
												 selectizeInput("m7.modeltype", "Model Type", choices = c("TimeSeriesArima","TimeSeriesExpSmooth"), selected="TimeSeriesArima", width = "40%"),
												 #numericInput("m7.avgyrs", label=h5("Avg Years (Naive Models)"), value = NULL , min = 1, max = 10, step = 1,   width = "40%"),
												 checkboxInput("m7.boxcox","Box-Cox Transf. - Time Series Models",value=FALSE)#,
												 #numericInput("m7.kfyear", label=h5("Avg Years for time-varying par (Kalman Filter Models)"), value = NULL , min = 1, max = 50, step = 1,   width = "40%")
								),
								tabPanel("TS3",
												 tags$h4("Time Series Model"),
												 tags$h5("All Data Types"),
												checkboxInput("m8.use","Include this model",value=TRUE),
												 textInput("m8.name", "Model Label", value = "TSExpSmoothBC", width = "40%"),
												 selectizeInput("m8.modeltype", "Model Type", choices = c("TimeSeriesArima","TimeSeriesExpSmooth"), selected="TimeSeriesExpSmooth", width = "40%"),
												 #numericInput("m8.avgyrs", label=h5("Avg Years (Naive Models)"), value = NULL , min = 1, max = 10, step = 1,   width = "40%"),
												 checkboxInput("m8.boxcox","Box-Cox Transf. - Time Series Models",value=TRUE)#,
												 #numericInput("m8.kfyear", label=h5("Avg Years for time-varying par (Kalman Filter Models)"), value = NULL , min = 1, max = 50, step = 1,   width = "40%")
								),
								tabPanel("TS4",
													tags$h4("Time Series Model"),
													tags$h5("All Data Types"),
													checkboxInput("m9.use","Include this model",value=TRUE),
												 textInput("m9.name", "Model Label", value = "TSExpSmoothNoBC", width = "40%"),
												 selectizeInput("m9.modeltype", "Model Type", choices = c("TimeSeriesArima","TimeSeriesExpSmooth"), selected="TimeSeriesExpSmooth", width = "40%"),
												 #numericInput("m9.avgyrs", label=h5("Avg Years (Naive Models)"), value = NULL , min = 1, max = 10, step = 1,   width = "40%"),
												 checkboxInput("m9.boxcox","Box-Cox Transf. - Time Series Models",value=FALSE)#,
												 #numericInput("m9.kfyear", label=h5("Avg Years for time-varying par (Kalman Filter Models)"), value = NULL , min = 1, max = 50, step = 1,   width = "40%")
								),
								tabPanel("Sib1",
												 tags$h4("Sibling Regression Model"),
												 tags$h5("Only works if your data has age classes"),
												 checkboxInput("m3.use","Include this model",value=FALSE),
											  textInput("m3.name", "Model Label", value = "SibRegSimple", width = "40%"),
											  selectizeInput("m3.modeltype", "Model Type", choices = c("SibRegSimple","SibRegLogPower","SibRegKalman","SibRegPooledSimple","SibRegPooledLogPower"), selected="SibRegSimple", width = "40%"),
											  numericInput("m3.kfyear", label=h5("Kalman Filter: Avg Years for time-varying par"), value = NULL , min = 1, max = 50, step = 1,   width = "40%"),
												numericInput("m3.max.pool", label=h5("SibReg Pooled (Simple or Log Power): Max cohorts to pool"), value = 3, min = 2, max = 5, step = 1,   width = "50%")
												),
								tabPanel("Sib2",
												 tags$h4("Sibling Regression Model"),
												 tags$h5("Only works if your data has age classes"),
												 checkboxInput("m4.use","Include this model",value=FALSE),
											  textInput("m4.name", "Model Label", value = "SibRegLogPower", width = "40%"),
											  selectizeInput("m4.modeltype", "Model Type", choices = c("SibRegSimple","SibRegLogPower","SibRegKalman","SibRegPooledSimple","SibRegPooledLogPower"), selected="SibRegLogPower", width = "40%"),
											  numericInput("m4.kfyear", label=h5("Avg Years for time-varying par (applies to Kalman Filter Models only)"), value = NULL , min = 1, max = 50, step = 1,   width = "40%"),
												 numericInput("m4.max.pool", label=h5("SibReg Pooled (Simple or Log Power): Max cohorts to pool"), value = 3, min = 2, max = 5, step = 1,   width = "50%")
											  ),
								tabPanel("Sib3",
												 tags$h4("Sibling Regression Model"),
												 tags$h5("Only works if your data has age classes"),
												 checkboxInput("m5.use","Include this model",value=FALSE),
											  textInput("m5.name", "Model Label", value = "SibRegKalman", width = "40%"),
											  selectizeInput("m5.modeltype", "Model Type", choices = c("SibRegSimple","SibRegLogPower","SibRegKalman","SibRegPooledSimple","SibRegPooledLogPower"), selected="SibRegKalman", width = "40%"),
											  numericInput("m5.kfyear", label=h5("Avg Years for time-varying par (applies to Kalman Filter Models only)"), value = 5 , min = 1, max = 50, step = 1,   width = "40%"),
												 numericInput("m5.max.pool", label=h5("SibReg Pooled (Simple or Log Power): Max cohorts to pool"), value = 3, min = 2, max = 5, step = 1,   width = "50%")
											  ),
								tabPanel("SibCov",
												 tags$h4("Sibling Regression Model with Covariates"),
												 tags$h5("Only works if your data has age classes  and covariates ('Cov_XYZ')"),
												 checkboxInput("m12.use","Include this model",value=FALSE),
												 textInput("m12.name", "Model Label", value = "SibRegComplex", width = "40%"),
												 selectizeInput("m12.modeltype", "Model Type", choices = c("SibRegComplex"), selected="SibRegComplex", width = "40%"),
												 numericInput("m12.tol.AIC", label=h5("SibReg Complex: Tolerance AIC [1-0]"), value = 0.75, min = 0, max = 1, step = 0.1,   width = "25%"),
			  								numericInput("m12.tol.r.sq", label=h5("SibReg Complex: Tolerance R2 [0-1]"), value = 0.02, min = 0, max = 1, step = 0.1,   width = "25%")
								),
								tabPanel("Rate",
												 tags$h4("Return Rate (Mechanistic) Model"),
												 tags$h5("Only works if your data has age classes and predictor ('Pred_XYZ') variables"),
												 tags$h5("(e.g. juvenile outmigration or hatchery releases)"),
												 checkboxInput("m11.use","Include this model",value=FALSE),
												 textInput("m11.name", "Model Label", value = "ReturnRate1", width = "40%"),
												 selectizeInput("m11.modeltype", "Model Type", choices = c("ReturnRate"), selected="ReturnRate", width = "40%"),
												 uiOutput("m11.pred.var.menu"),
												 selectizeInput("m11.rate.avg", "Avg", choices = c("wtmean","mean", "median"), selected="wtmean"),
												 numericInput("m11.last.n", "Last n obs",  value = 100 , min = 1, max = 100, step = 1,   width = "50%")
								),

							tabPanel("NoAgeCovar",
							         tags$h4("NoAge with Covariates Model"),
							         tags$h5("Only works if your data has no age classes, but has covariates ('Cov_XYZ')"),
							         checkboxInput("m15.use","Include this model",value=FALSE),
							         textInput("m15.name", "Model Label", value = "NoAgeCovar", width = "40%"),
							         selectizeInput("m15.modeltype", "Model Type", choices = c("NoAgeCovar"), selected="NoAgeCovar", width = "40%"),
							         numericInput("m15.tol.AIC", label=h5("SibReg Complex: Tolerance AIC [1-0]"), value = 0.75, min = 0, max = 1, step = 0.1,   width = "25%"),
							         numericInput("m15.tol.r.sq", label=h5("SibReg Complex: Tolerance R2 [0-1]"), value = 0.02, min = 0, max = 1, step = 0.1,   width = "25%")
							),
							tabPanel("Any 1",checkboxInput("m10.use","Include this model",value=FALSE),
											  textInput("m10.name", "Model Label", value = NULL, width = "40%"),
											  selectizeInput("m10.modeltype", "Model Type", choices = model.types, selected=NULL, width = "40%"),
											  numericInput("m10.avgyrs", label=h5("Avg Years (Naive Models)"), value = NULL , min = 1, max = 10, step = 1,   width = "40%"),
											  checkboxInput("m10.boxcox","Box-Cox Transf. - Time Series Models",value=FALSE),
											  numericInput("m10.kfyear", label=h5("Avg Years for time-varying par (applies to Sibling Regression with Kalman Filter Models)"),
											  						 value = NULL , min = 1, max = 50, step = 1,   width = "40%"),
											 uiOutput("m10.pred.var.menu"),
											 selectizeInput("m10.rate.avg", "Rate: Avg", choices = c("wtmean","mean", "median"), selected="wtmean"),
											 numericInput("m10.last.n", "Rate: Last n obs",  value = 100 , min = 1, max = 100, step = 1,   width = "50%"),
											 numericInput("m10.tol.AIC", label=h5("SibReg Complex: Tolerance AIC [1-0]"), value = 0.75, min = 0, max = 1, step = 0.1,   width = "25%"),
											 numericInput("m10.tol.r.sq", label=h5("SibReg Complex: Tolerance R2 [0-1]"), value = 0.02, min = 0, max = 1, step = 0.1,   width = "25%")

											 ) ,

							
							tabPanel("Any 2", 
							         checkboxInput("m13.use","Include this model",value=FALSE),
							         textInput("m13.name", "Model Label", value = NULL, width = "40%"),
							         selectizeInput("m13.modeltype", "Model Type", choices = model.types, selected=NULL, width = "40%"),
							         numericInput("m13.avgyrs", label=h5("Avg Years (Naive Models)"), value = NULL , min = 1, max = 10, step = 1,   width = "40%"),
							         checkboxInput("m13.boxcox","Box-Cox Transf. - Time Series Models",value=FALSE),
							         numericInput("m13.kfyear", label=h5("Avg Years for time-varying par (applies to Sibling Regression with Kalman Filter Models)"),
							                      value = NULL , min = 1, max = 50, step = 1,   width = "40%"),
							         uiOutput("m13.pred.var.menu"),
							         selectizeInput("m13.rate.avg", "Rate: Avg", choices = c("wtmean","mean", "median"), selected="wtmean"),
							         numericInput("m13.last.n", "Rate: Last n obs",  value = 100 , min = 1, max = 100, step = 1,   width = "50%"),
							         numericInput("m13.tol.AIC", label=h5("SibReg Complex: Tolerance AIC [1-0]"), value = 0.75, min = 0, max = 1, step = 0.1,   width = "25%"),
							         numericInput("m13.tol.r.sq", label=h5("SibReg Complex: Tolerance R2 [0-1]"), value = 0.02, min = 0, max = 1, step = 0.1,   width = "25%")
							         
							) ,
							
							tabPanel("Any 3", 
						checkboxInput("m14.use","Include this model",value=FALSE),
							         textInput("m14.name", "Model Label", value = NULL, width = "40%"),
							         selectizeInput("m14.modeltype", "Model Type", choices = model.types, selected=NULL, width = "40%"),
							         numericInput("m14.avgyrs", label=h5("Avg Years (Naive Models)"), value = NULL , min = 1, max = 10, step = 1,   width = "40%"),
							         checkboxInput("m14.boxcox","Box-Cox Transf. - Time Series Models",value=FALSE),
							         numericInput("m14.kfyear", label=h5("Avg Years for time-varying par (applies to Sibling Regression with Kalman Filter Models)"),
							                      value = NULL , min = 1, max = 50, step = 1,   width = "40%"),
							         uiOutput("m14.pred.var.menu"),
							         selectizeInput("m14.rate.avg", "Rate: Avg", choices = c("wtmean","mean", "median"), selected="wtmean"),
							         numericInput("m14.last.n", "Rate: Last n obs",  value = 100 , min = 1, max = 100, step = 1,   width = "50%"),
							         numericInput("m14.tol.AIC", label=h5("SibReg Complex: Tolerance AIC [1-0]"), value = 0.75, min = 0, max = 1, step = 0.1,   width = "25%"),
							         numericInput("m14.tol.r.sq", label=h5("SibReg Complex: Tolerance R2 [0-1]"), value = 0.02, min = 0, max = 1, step = 0.1,   width = "25%")
							         
							) 
							
		
				

								 ) # end nested tabsetpanel
								 ), # end tab panel for settings
                  tabPanel("Point Forecasts",  DT::dataTableOutput("table.multi.ptfc"),
							downloadButton("download.ptfc.table.merged","Download")
							),

                  tabPanel("Intervals",  DT::dataTableOutput("compare.int.table")
							),



	tabPanel("Model Selection", DT::dataTableOutput("table.bestmodels"),
								downloadButton("download.bestmodels.table","Download")
							),
				 # tabPanel("x Pt FC w/ Best Models",  DT::dataTableOutput("table.bestmodel.fc")) ,
				  #tabPanel("x Bootstrap",  DT::dataTableOutput("table.bestmodel.fc.boot"))
	
				tabPanel("FC Plot - By Age",
				         fluidRow(column(1),
				                  column(4,selectizeInput("compare.ageclass", "Age Class", choices = ages.menu.list.multi, selected=ages.menu.list[1])),
				                  column(4,selectizeInput("compare.plotsort", "Sort Plot By", choices = c("AvgRank","Forecast"), selected="AvgRank"))		                 
				         )       ,
				      		h2(textOutput("compare.ageclass"), align = "center"),
									plotOutput("compare.ptfc",width = "100%", height = "600px")	),

				tabPanel("Ranking Details",
				tabsetPanel(type = "tabs",

				 tabPanel("Rank - Across Ages", DT::dataTableOutput("table.cumul.ranking")) ,

				  tabPanel("Perf. - By Age",
									#h2(textOutput("compare.ageclass"), align = "center"), # crashes the data loading???? DTpackage issue???? - using caption for now
									DT::dataTableOutput("table.retropm")) ,
				  tabPanel("Rank - By Age",
									#h2(textOutput("compare.ageclass"), align = "center"), # crashes the data loading???? DTpackage issue????  - using caption for now
									DT::dataTableOutput("table.ranking"))
							)),


	tabPanel("Report",  value= "custom.report",

					 fluidPage(

					 	titlePanel("Report Download"),

					 	fluidRow(
					 		column(8,
					 					 tags$h2("Standard Reports"),
					 					 tags$h4("Short Report in MS Word: Summary of forecasts and model ranks"),
					 					 selectizeInput("shortreport.plotsort", "Sort Plots By", choices = c("AvgRank","Forecast"), selected="AvgRank"),
					 					 downloadButton("downloadComparisonRepWordShort", "Download SHORT MSWord report"),
					 					 tags$hr(),
					 					 tags$h4("Long Report in MS Word: Also includes detailed forecast and ranking tables by age"),
					 					 selectizeInput("longreport.plotsort", "Sort Plots By", choices = c("AvgRank","Forecast"), selected="AvgRank"),
					 					 downloadButton("downloadComparisonRepWordLong", "Download LONG MSWord report")


					 		)
					 	)
					 )



	)  # end custom reports tab panel






				  )




		) # end main panel

		) #end page with side bar for model comparison

	)


######### CUSTOM REPORTS	#############











) # end navbar Page


