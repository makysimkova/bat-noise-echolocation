# Reproduces every table and figure from data/raw/.
# Run from the project root:  Rscript run_all.R

scripts <- c(
  "00_setup.R",
  "01_bat_activity.R",
  "02_lmm_models.R",
  "03_effect_sizes_figure.R"
)

for (script in scripts) {
  message("Running ", script)
  source(file.path("R", script))
}
