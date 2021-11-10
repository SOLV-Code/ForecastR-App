#### Version 1.0: 2021-11-15

You are working with the first full release of the SalmonForecastR App.
The ForecastR team is trying to address quirks and bugs
as they are found by users like you. 

To check a list of know bugs/issues with this prototype, 
and to add any new bugs/issues with this prototype,
go to **[this github thread](https://github.com/SalmonForecastR/ForecastR-Releases/issues/1)**

For more information about the app, check the *Help* and *About* tabs.

**What's New?**

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


