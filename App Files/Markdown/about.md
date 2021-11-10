### Citation

**Project Proposal to the Pacific Salmon Commission**

Vélez-Espino, L.A., Parken, C.K., Clemons, E.R., Peterson, R., and Ryding, K. 2018. Automating procedures for forecasting of terminal run and escapement of Chinook, Coho and Chum salmon stocks using open-source statistical software: Chapter 2. Southern Boundary Restoration and Enhancement Fund, Pacific Salmon Commission, Vancouver BC.

**Final Report**

Vélez-Espino, L.A., Parken, C.K., Clemons, E.R., Peterson, R., Ryding, K., Folkes, M., and Pestal, G. (2019). ForecastR: tools to automate procedures for forecasting of salmonid terminal run and escapement. Final Report submitted to the Southern Boundary Restoration and Enhancement Fund, Pacific Salmon Commission, Vancouver BC.
[Available Online](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwiMi47T1rrvAhVVJjQIHQ-nCNYQFjAGegQIChAD&url=https%3A%2F%2Fwww.psc.org%2Fdownload%2F585%2Fvery-high-priority-chinook%2F11704%2Fs18-vhp15a-forecastr-tools-to-automate-forecasting-procedures-for-salmonid-terminal-run-and-escapement.pdf&usg=AOvVaw2ZHMiJb0dBhjytGgM8lgvZ)

### Project Overview

The annual exercise of forecasting terminal run or escapement is a critical aspect of management and conservation of salmonids. ForecastR relies on the open-source statistical software R to generate age-specific (or total abundance) forecasts of escapement or terminal run using a variety of generic models, enabling the users to perform the following interactive tasks with the help of a Graphical user Interface (GUI). These tasks include: (a) the selection of forecasting approaches from a wide set of statistical and/or mechanistic models for forecasting terminal run, escapement or pre-fishery abundance (production); (b) the selection of several measures of retrospective forecast performance (e.g., MRE, MAE, MAPE, MASE, RMSE); (c) the comparison of best forecasting models and model ranking based on the selected performance metrics; and, (d) the reporting of forecasting results (point forecasts and interval forecasts) and diagnostics by producing either a detailed report or an executive-summary report. 

The original design of ForecastR involves the generation of age-specific or total-abundance forecasts using a variety of generic models, including: (i) simple and complex sibling regressions with the ability to include environmental covariates; (ii) time series models such as ARIMA, exponential smoothing, and naïve models (based on preceding 1 year, 3 years or 5 years in abundance time series); and (iii) mechanistic models such as average return rate models that depend on auxiliary data such as the number of outmigrant juveniles, the number of hatchery fish released or the number spawners. For both age-structured and non-age-structured data, AIC-based model selection takes place within model types prior to model ranking across model types based on the abovementioned metrics of retrospective evaluation.

The current phase of the ForecastR project produced the *forecastR_phase4* release, which incorporated improvements and refinements to the GUI, the complex-sibling-regression module, and the mechanistic-model module. An important development of this phase of the project involved the incorporation of a Kalman Filter sibling regressions module to consider the effects on forecasts of potential trends in survival or maturity. The inclusion in ForecastR of a Kalman filter module responds to recommendations to the PSC in *Review of Methods for Forecasting Chinook Salmon Abundance in the Pacific Salmon Treaty Areas* (Peterman, Beamesderfer and Bue, 2016). In addition, new ForecastR's features have been envisioned by the proponents of this project to enhance its current capabilities. Examples of these additional features include the incorporation of GLM-based sibling models (to address violations to normality assumptions and provide greater flexibility to sibling regressions) and the development of an alternative retrospective forecast evaluation for regression models using *dynamic* best models. 

### Timelines
* Project Start: April 1, 2018
* Project Completion: January 30, 2019
* Release of *forecastR_phase4*: February 15, 2019


### Contributors
* Antonio Velez-Espino:Fisheries and Oceans Canada, Pacific Biological Station, Nanaimo BC 
* Charles K. Parken: Fisheries and Oceans Canada, Kamloops BC
* Ethan Clemons: Oregon Department of Fish and Wildlife, Newport, OR
* Randy Peterson: Alaska Department of Fish and Game, Juneau, AK
* Kristen Ryding: Washington Department of Fish and Wildlife, Olympia, WA   
* Isabella Ghement: Ghement Statistical Consulting Company Ltd. 
* Gottfried Pestal: SOLV Consulting Ltd. 
* Michael Folkes: Fisheries and Oceans Canada, Pacific Biological Station, Nanaimo BC 
* Carrie Holt: Fisheries and Oceans Canada, Pacific Biological Station, Nanaimo BC   

### References
Peterman, R.M., Beamesderfer, R., and Bue, B. 2016. Review of Methods for Forecasting Chinook Salmon Abundance in the Pacific Salmon Treaty Areas. Report to the Pacific Salmon Commission.165 p.



