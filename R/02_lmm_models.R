# Linear mixed models of pulse-level call parameters (thesis Appendices F and H).
# For each focal species and call parameter, a noise model (NDSI) and a habitat model
# (woodland cover within 200 m) are fitted separately, because the two predictors are correlated.
#   Response ~ [noise_window +] NDSI or woodland + temperature + humidity + (1 | site/file)
# Outputs: outputs/tables/lmm_results.csv, lmm_r2.csv, lmm_variance_partition.csv,
#          outputs/figures/figS1_lmm_diagnostics.pdf

# Continuous predictors are standardised across all pulses before splitting by species
pulses <- read_csv(path_raw("pulses.csv"), show_col_types = FALSE) |>
  mutate(
    site        = factor(site),
    ndsi_sc     = as.numeric(scale(mean_ndsi)),
    temp_sc     = as.numeric(scale(tempmin)),
    humid_sc    = as.numeric(scale(humidity)),
    woodland_sc = as.numeric(scale(woodland_200m))
  )

ndsi_woodland_r <- cor(pulses$mean_ndsi, pulses$woodland_200m)

responses <- c(Fc = "Fc_kHz", Dur = "log(duration_ms)", BW = "log(bandwidth_kHz)", TBC = "log(tbc_ms)")
predictors <- c(noise = "ndsi_sc", habitat = "woodland_sc")

fit_species_models <- function(df) {
  window_counts <- table(df$noise_window)
  use_window <- length(window_counts) == 2 && min(window_counts) >= MIN_PULSES_PER_WINDOW
  models <- list()
  for (r in names(responses)) for (p in names(predictors)) {
    rhs <- paste(c(if (use_window) "noise_window", predictors[[p]], "temp_sc", "humid_sc",
                   "(1 | site/file)"), collapse = " + ")
    models[[paste(r, p, sep = "_")]] <- lmer(as.formula(paste(responses[[r]], "~", rhs)),
                                             data = df, REML = TRUE)
  }
  models
}

models <- pulses |>
  filter(species %in% FOCAL_SPECIES) |>
  split(~species) |>
  map(fit_species_models)

for_each_model <- function(f) {
  imap_dfr(models, function(species_models, sp) {
    imap_dfr(species_models, function(m, name) mutate(f(m), species = sp, model = name, .before = 1))
  })
}

significance <- function(p) {
  case_when(p < 0.001 ~ "***", p < 0.01 ~ "**", p < 0.05 ~ "*", p < 0.1 ~ ".", TRUE ~ "")
}

lmm_results <- for_each_model(function(m) tidy(m, effects = "fixed", conf.int = TRUE)) |>
  filter(term != "(Intercept)") |>
  select(species, model, term, estimate, std.error, conf.low, conf.high, statistic, p.value) |>
  mutate(sig = significance(p.value))
write_csv(lmm_results, path_tables("lmm_results.csv"))

lmm_r2 <- for_each_model(function(m) {
  r2 <- suppressWarnings(r.squaredGLMM(m))
  tibble(R2_marginal = r2[1, "R2m"], R2_conditional = r2[1, "R2c"])
})
write_csv(lmm_r2, path_tables("lmm_r2.csv"))

lmm_variance <- for_each_model(function(m) {
  vc <- as.data.frame(VarCorr(m))
  share <- function(group) vc$vcov[vc$grp == group] / sum(vc$vcov)
  tibble(var_file = share("file:site"), var_site = share("site"), var_residual = share("Residual"))
})
write_csv(lmm_variance, path_tables("lmm_variance_partition.csv"))

# Residual and random-effect diagnostics, one page per model
pdf(path_figures("figS1_lmm_diagnostics.pdf"), width = 9, height = 3.2)
for (sp in names(models)) for (name in names(models[[sp]])) {
  m <- models[[sp]][[name]]
  par(mfrow = c(1, 3), oma = c(0, 0, 2, 0))
  plot(fitted(m), resid(m), xlab = "Fitted", ylab = "Residual", pch = 16, cex = 0.4)
  abline(h = 0, lty = 2)
  qqnorm(resid(m), main = "Residuals", pch = 16, cex = 0.4); qqline(resid(m))
  qqnorm(ranef(m)$`file:site`[, 1], main = "File random effects", pch = 16, cex = 0.6)
  qqline(ranef(m)$`file:site`[, 1])
  mtext(paste(focal_labels[[sp]], name), outer = TRUE, font = 2)
}
invisible(dev.off())
