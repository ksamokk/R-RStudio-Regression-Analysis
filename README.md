# R / RStudio: AI in Russian IT Companies

### Econometric Analysis of Managerial AI Integration and Operational Performance

**Research project | 23 large Russian IT companies | 2019–2025**

**Authors:** Ekaterina Filimonova and Ksenia Samokhina

## Project Overview

This research examines the relationship between managerial artificial intelligence (AI) integration and the operational performance of large Russian IT companies. It also investigates whether firm size moderates this relationship.

The study uses panel data for 23 large Russian IT companies over 2019–2025 and applies regression models in R.

## Research Questions

- Is managerial AI integration associated with labor productivity?
- Is managerial AI integration associated with return on assets (ROA)?
- Is managerial AI integration associated with capital expenditure intensity?
- Does firm size moderate these relationships?

## Tools and Technologies

- **R / RStudio:** Data preparation, statistical analysis, regression modeling, and diagnostics
- **Microsoft Excel:** Research dataset
- **R packages:** `readxl`, `dplyr`, `psych`, `ggplot2`, `car`, `lmtest`, `sandwich`

## Variables

- **Dependent variables:** Labor productivity, ROA, capital expenditure intensity
- **Main explanatory variable:** Managerial AI integration
- **Moderator:** Firm size (log of assets)
- **Controls:** Firm age and leverage
- **Additional model terms:** Year effects

## Methodology

1. Prepare data and construct managerial AI integration variables.
2. Transform labor productivity using the natural logarithm and filter extreme observations using the 1st and 99th percentiles.
3. Calculate descriptive statistics and Pearson correlations.
4. Estimate baseline regression models for three operational performance indicators.
5. Test moderation by including an interaction between centered managerial AI integration and centered firm size.
6. Evaluate models using adjusted R-squared, HC1 heteroskedasticity-robust standard errors, and variance inflation factors (VIF).

## Key Findings

- The direct positive relationship between managerial AI integration and the three operational indicators was not supported.
- Firm size positively moderated the relationship between managerial AI integration and ROA.
- The moderating relationship was not supported for labor productivity or capital expenditure intensity.

These results suggest that managerial AI integration does not automatically improve operational performance; organizational context may matter.

## Project Files

The repository contains the following project files:

- `ai_it_companies_analysis.R` — R analysis script
- `ai_it_companies_data.xlsx` — research dataset
- `research_paper.pdf` — full academic paper
- `research_presentation.pdf` — defense presentation

## Skills Demonstrated

**Business Analytics · Econometrics · Data Preparation · Regression Analysis · Moderation Analysis · Statistical Diagnostics · R Programming**

## Research Materials

- [R Analysis Script](ai_it_companies_analysis.R)
- [Research Dataset (Excel)](ai_it_companies_data.xlsx)
- [Full Research Paper (PDF)](research_paper.pdf)
- [Defense Presentation (PDF)](research_presentation.pdf)
