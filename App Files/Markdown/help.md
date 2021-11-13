### The ForecastR App

This app is a standalone front-end for the functions contained
in the *forecastR package*. For project updates and technical details 
go to the [*main project repository*](https://github.com/SalmonForecastR/SalmonForecastR).

### Troubleshooting Tips




#### App Troubles

First, narrow down the source of the problem:


* If nothing works, check the formatting of your data file against the [sample input files](https://www.dropbox.com/sh/7pdqfmvn16v59uk/AAB52T_T8ItI0uEsjyk6PVXxa?dl=0).
* If a specific model doesn't work on the *Explore Tab*, try changing one of the settings (e.g. if the retrospective interval doesn't work, check the prediction interval instead).
* If the *Compare Tab* doesn't work, check each candidate model *with the exact same settings on the *Explore Tab*.
* If you are comfortable with R, try fitting the same model using the package functions (Starting with this [Demo Script](https://github.com/SalmonForecastR/ForecastR-Releases/wiki/4-Using-the-ForecastR-package)).


Then, file a bug report at [Issue Page](https://github.com/SalmonForecastR/ForecastR-Releases/issues).




#### Statistical Troubles



* ForecastR doesn't accept time series with missing data. The inclusion of imputing algorithms was considered in previous developmental phases of ForecastR but the idea was abandoned in favor of external preparation of input files without missing data.

* Consider pooling age classes with very small numbers. These can cause fitting problems and crashes.

* The presence of  legitimate "zeros" in time series sometimes produces bizarre output and statistics in ForecastR. If this happens, user options are

   * to explore the alternative bootstrapping methods in ForecastR, maximum entropy ('meboot') or loess bootstrapping ('stlboot'),
   * to experiment with and without the inclusion of the Box-Cox transformation, or
   * to aggregate abundance data from two ages into a single age class. Imputing "ones" can sometime improve the quality of the output.

* Users need to be aware that forecasting models, but in particular time series models, require a reasonable number of data points. Time series long enough are necessary to produce reliable forecasts using the ARIMA or Exponential Smoothing modules. "Very" short time series (e.g., less than 15 data points) can be problematic for the operation of these modules.

* Note about *bootstrapping for Simple Sibling Regression* :The bootstrapping for the simple sibling regression model can be done discarding negative point forecasts during the bootstrapping process. However, this ad-hoc process will not necessarily guarantee adequate coverage for the resulting forecasting intervals and may result in a skewed distribution of bootstrapped point forecasts.The version of bootstrapping used in the Simple Sibling Regression in this release is based on resampling residuals and keeping negative point forecasts. Future versions of this module will have the following options:

   * resampling residuals and keeping negative point forecasts (should any be present);
   * resampling residuals but discarding negative point forecasts (should any be present);
   * resampling cases and keeping negative point forecasts  (where a case represents a row of the data set used to fit the model);
   * resampling cases  but discarding negative point forecasts.

* Note about *simple log power regression (SLPR)*:  there is no need to worry about negative point forecasts by virtue of the log transformation of the data.
