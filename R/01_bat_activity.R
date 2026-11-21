# Bat community and activity: thesis Figure 4 and Table 2.
# A bat pass is one or more calls of a species within a 5-second interval (Kerbiriou et al. 2019).
# Outputs: outputs/figures/fig4_passes_per_site.png, outputs/tables/passes_per_site.csv,
#          outputs/tables/table2_focal_passes.csv

passes_site_species <- read_csv(path_raw("passes_by_site_species.csv"), show_col_types = FALSE)

site_totals <- passes_site_species |>
  group_by(site) |>
  summarise(passes = sum(n_passes), species = n(), .groups = "drop") |>
  arrange(desc(passes))
write_csv(site_totals, path_tables("passes_per_site.csv"))

species_order <- passes_site_species |>
  group_by(common_name) |>
  summarise(total = sum(n_passes)) |>
  arrange(desc(total)) |>
  pull(common_name)

fig4 <- passes_site_species |>
  mutate(site        = factor(site, levels = site_totals$site),
         common_name = factor(common_name, levels = species_order)) |>
  ggplot(aes(site, n_passes, fill = common_name)) +
  geom_col(position = "stack", width = 0.7) +
  scale_fill_manual(values = species_colours, name = "Species") +
  labs(x = "Site", y = "Number of bat passes") +
  theme_bw(base_size = 12) +
  theme(legend.position = "right", panel.grid.major.x = element_blank())
save_fig(fig4, "fig4_passes_per_site.png", width = 9, height = 6)

# Table 2: focal-species passes in the analysis window (11-18 March 2026)
passes_window <- read_csv(path_raw("passes_analysis_window.csv"), show_col_types = FALSE) |>
  filter(species %in% FOCAL_SPECIES)

sites_present <- passes_window |>
  group_by(species) |>
  summarise(sites_present = n_distinct(site), .groups = "drop")

table2 <- passes_window |>
  filter(!is.na(noise_window)) |>
  count(species, noise_window) |>
  pivot_wider(names_from = noise_window, values_from = n, values_fill = 0) |>
  mutate(total = high_noise + low_noise, common_name = focal_labels[species]) |>
  left_join(sites_present, by = "species") |>
  select(common_name, species, total, high_noise, low_noise, sites_present) |>
  arrange(desc(total))
write_csv(table2, path_tables("table2_focal_passes.csv"))
