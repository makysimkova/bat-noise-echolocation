# Data

Passive acoustic monitoring at Copped Hall and Patmore Fields, Epping Forest, Essex, UK (10 March – 27 April 2026). The tables below are the analysis-ready outputs of the audio-processing stage, i.e. the inputs to the models and figures in the thesis. Licensed under CC BY 4.0.

**How the tables were produced:**
1. **Species identification:** ultrasonic WAV files were classified in Kaleidoscope Pro 5.7.0 (Bats of Europe 5.7.0, sensitivity −1). Noise and No-ID files were removed, and identifications with a match ratio below 0.8 were discarded.
2. **Noise:** NDSI (`soundecology`) was calculated from 48 kHz ambient recordings. For each site and noise window, up to 5 files per night were drawn, then 30 files at random.
3. **Pulse extraction:** pulses were extracted from triggered WAV files with `bioacoustics`.
   - Files tried: files with a focal species identification (match ratio ≥ 0.8) recorded within a noise window during the analysis week.
   - Settings: standard settings first; lenient settings for files that returned no pulses (thesis Appendix C).
   - Filtering: pulses outside each species' plausible characteristic-frequency range were removed (thesis Appendix D).
4. **Woodland:** broadleaved plus coniferous woodland as a proportion of land cover within 200 m of each detector, from the UKCEH Land Cover Map (not redistributable).

## `raw/pulses.csv`
One row per echolocation pulse used in the models: 4,371 pulses from 437 files, 11–18 March 2026.

| Column | Description |
|---|---|
| `site` | Site code (see `sites.csv`) |
| `file` | Source WAV file (recorder and timestamp) |
| `pulse_start` | Pulse start time within the file |
| `species` | Kaleidoscope identification: `PIPPIP`, `PIPPYG` or `NYCLEI` |
| `match_ratio` | Kaleidoscope match ratio for the file |
| `noise_window` | `high_noise` (19:00–22:00) or `low_noise` (03:00–06:00) |
| `date` | Night of recording |
| `Fc_kHz`, `Fmin_kHz`, `Fmax_kHz` | Characteristic, minimum and maximum frequency |
| `bandwidth_kHz` | Fmax − Fmin |
| `duration_ms` | Pulse duration |
| `tbc_ms` | Time since the previous pulse in the same file |
| `mean_ndsi` | Mean NDSI for the site and noise window (`ndsi_by_site_window.csv`) |
| `woodland_200m` | Woodland proportion within 200 m of the site (`woodland_200m.csv`) |
| `tempmin`, `humidity` | Nightly minimum temperature (°C) and humidity (%) for that date, as used in the models |

## `raw/ndsi_by_site_window.csv`
Mean and SD of NDSI per site and noise window, with the number of files sampled (thesis Appendix E).

## `raw/woodland_200m.csv`
Woodland proportion within 200 m of each detector (thesis Appendix B).

## `raw/sites.csv`
Detector positions, WGS84 decimal degrees (thesis Appendix G).

## `raw/passes_by_site_species.csv`
Bat passes per site and species over the full monitoring period, for all 12 sites with data (thesis Figure 4). A pass is one or more identified calls of a species within 5 seconds.

## `raw/passes_analysis_window.csv`
One row per bat pass during the analysis week (11–18 March 2026), all species, used for thesis Table 2.

| Column | Description |
|---|---|
| `site` | Site code |
| `species` | Kaleidoscope species code (`species_codes.csv`) |
| `date` | Night |
| `pass_id` | Pass number within site, species and night |
| `noise_window` | `high_noise`, `low_noise`, or empty if outside both windows |
| `n_calls` | Identified files in the pass |

## `raw/species_codes.csv`
Kaleidoscope species codes with Latin and common names.
