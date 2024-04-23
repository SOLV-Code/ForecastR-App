#### Version 2.1: 2024-04-23

You are working with an updated version of the *second* full release of the SalmonForecastR App.
The ForecastR team is trying to address quirks and bugs
as they are found by users like you. 

To check a list of know bugs/issues with this prototype, 
and to add any new bugs/issues with this prototype,
go to **[this github thread](https://github.com/SalmonForecastR/ForecastR-Releases/issues/6)**

For more information about the app, check the *Help* and *About* tabs.


**Important Reminders**


* Legal: The *ForecastR* app and package are being shared as free, open-source products without
any warranties or liabilities. For details, check the [GNU General Public License v3.0](https://github.com/SalmonForecastR/ForecastR-Releases/blob/main/LICENSE)
* Statistical: *ForecastR* doesn't have a quality-control step evaluating the data you feed in. It
can't decide which candidate models make sense for your data set, and which candidate forecast is the 
most appropriate. The design focus has been on automating the number-crunching steps to free up 
analysts' time for exploration and interpretation.

**What's New?**

*Version 2.1: Spring 2024 Update --------------------------------------------*

The only revision in this update deals with rounding of the input data.
Some models were crashing if input variables like escapement or terminal run
included values with decimals (e.g., after infilling). The new default is to round
these numbers when inputs are being read in, but for some use cases (e.g.,  time
series model of survival rates) the rounding needs to be turned off on 
**Setting Up/Data Treatement Settings**.

*Version 2: 2023 Update --------------------------------------------*

This round of work focused on improving the user experience, but we
also added a new type of forecasting model to both the R package and the app:

* *NoAgeCovar*: For data sets without age classes (e.g., only have total run or escapement) that have covariates,
fit generalized linear models (GLM) and select the best combination of covariates.

App improvements since the last major release include:

* *dynamic interfaces*
   - model-specific menus for settings
   - model-specific diagnostics
   - data-specific model selections (e.g. on the model selections for comparing and ranking)
* *Tooltips*: click on/off to display short clarifications for app components, some with links to further information.
* *Sample data*: sample data sets are now integrated into the app and can be selected from drop down menu
* *Increased the number of models that can be compared*





*Version 1: 2021 Release --------------------------------------------*

Since the last major release in the spring of 2019,
the following key updates have been implemented:

*More Forecast Options added to the package code
and to the app interface:*

* Return Rate (Mechanistic) Model: Forecast based observed smolts or hatchery release combined with observed juvenile to adult survival rate (from a user-specified time window).
* Pooled Sibling Regression Models: Sibling regression combining several younger cohorts into a single index to look for a more stable signal.
* Complex Sibling Regression Models: include up to 3 covariates (with interaction terms) and automated model selection.

For an overview of these models and how they are implemented, check the [Salmon ForecastR wiki](https://github.com/SalmonForecastR/ForecastR-Releases/wiki). For details, check out the latest **[ForecastR Report](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwiMi47T1rrvAhVVJjQIHQ-nCNYQFjAGegQIChAD&url=https%3A%2F%2Fwww.psc.org%2Fdownload%2F585%2Fvery-high-priority-chinook%2F11704%2Fs18-vhp15a-forecastr-tools-to-automate-forecasting-procedures-for-salmonid-terminal-run-and-escapement.pdf&usg=AOvVaw2ZHMiJb0dBhjytGgM8lgvZ)**


*App Interface Improvements:*

* Explore tab options dynamically respond to data set and model selection (e.g. only show sibling regression model options
if data has age classes, menu options for model settings adapt to model selection)
*  Compare tab model selection re-design: have tabs for each model type now, with model-specific options.

*Report Generation (MS Word Output)*:

* functionality expanded



