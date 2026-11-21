# Thesis Figure 5: standardised effects of NDSI (noise models) and woodland cover
# (habitat models) on each call parameter, with 95% confidence intervals.
# Filled symbols mark p < 0.1, as in the submitted figure.
# Output: outputs/figures/fig5_lmm_effects.png

model_colours <- c("Noise (NDSI)" = "#2166ac", "Habitat (% woodland)" = "orange")

effects <- lmm_results |>
  filter(term %in% c("ndsi_sc", "woodland_sc")) |>
  mutate(
    model_type = if_else(grepl("noise", model), "Noise (NDSI)", "Habitat (% woodland)"),
    response   = factor(sub("_.*", "", model), levels = c("Fc", "BW", "Dur", "TBC"),
                        labels = c("Fc (kHz)", "log(Bandwidth)", "log(Duration)", "log(TBC)")),
    species    = factor(focal_labels[species], levels = focal_labels),
    marked     = p.value < 0.1,
    pt_size    = if_else(marked, 3.2, 2.8)
  )

fig5 <- ggplot(effects, aes(estimate, model_type, colour = model_type)) +
  geom_vline(xintercept = 0, linetype = "dashed", colour = "grey50", linewidth = 0.4) +
  geom_errorbar(aes(xmin = conf.low, xmax = conf.high), orientation = "y", width = 0, linewidth = 0.7) +
  geom_point(aes(shape = model_type, size = I(pt_size)), stroke = 0.9, fill = NA) +
  geom_point(data = filter(effects, marked),
             aes(shape = model_type, fill = model_type, size = I(pt_size)), stroke = 0.9) +
  geom_text(data = filter(effects, marked), aes(x = conf.high, label = sig),
            hjust = -0.3, vjust = 0.4, size = 3, fontface = "bold", show.legend = FALSE) +
  facet_grid(species ~ response, scales = "free_x", switch = "y") +
  scale_shape_manual(values = c("Noise (NDSI)" = 21, "Habitat (% woodland)" = 22), guide = "none") +
  scale_fill_manual(values = model_colours, guide = "none") +
  scale_colour_manual(values = model_colours, name = "Model:",
                      guide = guide_legend(override.aes = list(shape = c(21, 22),
                                                               fill = unname(model_colours[c(2, 1)]),
                                                               size = 3))) +
  labs(x = "Standardised effect size", y = "Species") +
  theme_bw(base_size = 10) +
  theme(
    strip.background   = element_rect(fill = "grey92", colour = "grey70"),
    strip.text.x       = element_text(face = "bold", size = 9),
    strip.text.y.left  = element_text(face = "italic", size = 9, angle = 90),
    strip.placement    = "outside",
    axis.title.x       = element_text(size = 9.5, margin = margin(t = 6)),
    axis.text.x        = element_text(size = 7.5),
    axis.text.y        = element_blank(),
    axis.ticks.y       = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.minor   = element_blank(),
    panel.grid.major.x = element_line(colour = "grey90", linewidth = 0.3),
    legend.position    = "bottom",
    legend.title       = element_text(size = 8.5, face = "bold"),
    legend.text        = element_text(size = 8.5),
    legend.key.size    = unit(0.5, "cm"),
    panel.spacing.x    = unit(0.8, "lines"),
    panel.spacing.y    = unit(0.6, "lines")
  )
save_fig(fig5, "fig5_lmm_effects.png", width = 8, height = 6)
