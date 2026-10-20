#The effect of the use of artificial intelligence by managers on the 
#operational indicators of IT companies: analysis of the largest Russian firms
# Authors: Filimonova Ekaterina, Samokhina Ksenia
# Research advisor: L.A. Kezhun
# DV:  Labor productivity, ROA, capital investment intensity
# IV:  Managerial AI integration
# Controls : Firm age, leverage
# MOD: Firm size

library(readxl)
library(dplyr)
library(psych)
library(ggplot2)
library(car)
library(lmtest)

data <- read_excel("ai_it_companies_data.xlsx", sheet = "Data")

# DATA PREPARATION AND VARIABLE CODING
data <- data %>%
  mutate(
    managerial_ai_integration = ifelse(ai_mentions_total > 0,
                                       ai_manager_mentions / ai_mentions_total, 0),
    ai_x_managerial = ai_adoption_dummy * managerial_ai_integration,
    log_labor_prod = log(labor_productivity),
    year_factor = factor(year)
  )

vars <- c("labor_productivity", "roa", "capex_intensity")

for (v in vars) {
  q <- quantile(data[[v]], c(0.01, 0.99), na.rm = TRUE)
  data <- data[data[[v]] >= q[1] & data[[v]] <= q[2], ]
}

# DESCRIPTIVE STATISTICS
vars_desc <- c("log_labor_prod", "roa", "capex_intensity",
               "managerial_ai_integration", "ai_adoption_dummy",
               "log_assets", "firm_age", "leverage")

describe(data[vars_desc])
round(prop.table(table(data$ai_adoption_dummy)) * 100, 2)

# PEARSON CORRELATION MATRIX
cor_vars <- c(
  "log_labor_prod",
  "roa",
  "capex_intensity",
  "managerial_ai_integration",
  "log_assets",
  "firm_age"
)

cor_result <- corr.test(data[cor_vars])
round(cor_result$r, 2)
print(cor_result$stars)

# REGRESSION MODELS
# H1: Baseline models
# Model 1: DV = log labor productivity
model_h1_labor <- lm(
  log_labor_prod ~ managerial_ai_integration +
    log_assets + firm_age + leverage + year_factor,
  data = data
)
summary(model_h1_labor)

# Model 2: DV = ROA
model_h1_roa <- lm(
  roa ~ managerial_ai_integration +
    log_assets + firm_age + leverage + year_factor,
  data = data
)
summary(model_h1_roa)

# Model 3: DV = capex intensity
model_h1_capex <- lm(
  capex_intensity ~ managerial_ai_integration +
    log_assets + firm_age + leverage + year_factor,
  data = data
)
summary(model_h1_capex)

# H2: Moderation models
# Сentered variables for H2
data <- data %>%
  mutate(
    managerial_ai_c = managerial_ai_integration - mean(managerial_ai_integration, na.rm = TRUE),
    log_assets_c = log_assets - mean(log_assets, na.rm = TRUE),
    ai_x_size_c = managerial_ai_c * log_assets_c
  )

# Model 1: DV = log labor productivity
model_h2_labor <- lm(
  log_labor_prod ~ managerial_ai_c + log_assets_c + ai_x_size_c +
    firm_age + leverage + year_factor,
  data = data
)
summary(model_h2_labor)

# Model 2: DV = ROA
model_h2_roa <- lm(
  roa ~ managerial_ai_c + log_assets_c + ai_x_size_c +
    firm_age + leverage + year_factor,
  data = data
)
summary(model_h2_roa)

# Model 3: DV = capex intensity 
model_h2_capex <- lm(
  capex_intensity ~ managerial_ai_c + log_assets_c + ai_x_size_c +
    firm_age + leverage + year_factor,
  data = data
)
summary(model_h2_capex)

# MODEL FIT
# Model fit for H1

cat(sprintf("H1 Model 1 Adjusted R² = %.3f\n", summary(model_h1_labor)$adj.r.squared))
cat(sprintf("H1 Model 2 Adjusted R² = %.3f\n", summary(model_h1_roa)$adj.r.squared))
cat(sprintf("H1 Model 3 Adjusted R² = %.3f\n", summary(model_h1_capex)$adj.r.squared))

# Model fit for H2

cat(sprintf("H2 Model 1 Adjusted R² = %.3f\n", summary(model_h2_labor)$adj.r.squared))
cat(sprintf("H2 Model 2 Adjusted R² = %.3f\n", summary(model_h2_roa)$adj.r.squared))
cat(sprintf("H2 Model 3 Adjusted R² = %.3f\n", summary(model_h2_capex)$adj.r.squared))

# ROBUST STANDARD ERRORS
library(lmtest)
library(sandwich)

h1_labor_robust <- coeftest(model_h1_labor, vcov = vcovHC(model_h1_labor, type = "HC1"))
h1_roa_robust <- coeftest(model_h1_roa, vcov = vcovHC(model_h1_roa, type = "HC1"))
h1_capex_robust <- coeftest(model_h1_capex, vcov = vcovHC(model_h1_capex, type = "HC1"))

h2_labor_robust <- coeftest(model_h2_labor, vcov = vcovHC(model_h2_labor, type = "HC1"))
h2_roa_robust <- coeftest(model_h2_roa, vcov = vcovHC(model_h2_roa, type = "HC1"))
h2_capex_robust <- coeftest(model_h2_capex, vcov = vcovHC(model_h2_capex, type = "HC1"))

h1_labor_robust
h1_roa_robust
h1_capex_robust

h2_labor_robust
h2_roa_robust
h2_capex_robust

# Diagnostics
# VIF diagnostics for H1
vif_h1 <- lm(
  log_labor_prod ~ managerial_ai_integration +
    log_assets + firm_age + leverage,
  data = data
)
vif(vif_h1)

nobs(model_h1_labor)
nobs(model_h1_roa)
nobs(model_h1_capex)

# VIF diagnostics for H2
vif_h2 <- lm(
  log_labor_prod ~ managerial_ai_c + log_assets_c + ai_x_size_c +
    firm_age + leverage,
  data = data
)
vif(vif_h2)

nobs(model_h2_labor)
nobs(model_h2_roa)
nobs(model_h2_capex)
