# Packages, paths, study constants and shared plotting settings used by every script.

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(readr)
  library(purrr)
  library(tibble)
  library(forcats)
  library(ggplot2)
  library(lme4)
  library(lmerTest)
  library(broom.mixed)
  library(MuMIn)
  library(here)
})

path_raw     <- function(...) here("data", "raw", ...)
path_figures <- function(...) here("outputs", "figures", ...)
path_tables  <- function(...) here("outputs", "tables", ...)

# Focal species: the three with the most passes across sites
FOCAL_SPECIES <- c("PIPPIP", "PIPPYG", "NYCLEI")
focal_labels  <- c(PIPPIP = "Common pipistrelle", PIPPYG = "Soprano pipistrelle", NYCLEI = "Leisler's bat")

# Minimum pulses per noise window for the noise-window contrast to enter a model
MIN_PULSES_PER_WINDOW <- 30

species_colours <- c(
  "Common pipistrelle"     = "#2E75B6", "Soprano pipistrelle"   = "#70AD47",
  "Leisler's bat"          = "#ED7D31", "Common noctule"        = "#FFC000",
  "Daubenton's bat"        = "#9B59B6", "Nathusius' pipistrelle" = "#E74C3C",
  "Natterer's bat"         = "#1ABC9C", "Whiskered bat"         = "#E91E63",
  "Bechstein's bat"        = "#607D8B", "Brown long-eared bat"  = "#F39C12",
  "Grey long-eared bat"    = "#BDC3C7", "Barbastelle"           = "#2C3E50",
  "Lesser horseshoe bat"   = "#8E44AD", "Greater horseshoe bat" = "#C0392B",
  "Serotine bat"           = "#E16A86"
)

save_fig <- function(plot, filename, width, height) {
  ggsave(path_figures(filename), plot, width = width, height = height, dpi = 300, bg = "white")
}
