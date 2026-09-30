# MAIN PIPELINE RUNNER

stage_scripts <- c(
  "R/00_parameters.R",          # user-editable settings (paths, primers, thresholds)
  "R/01_helpers.R",             # small shared helpers
  "R/02_quality_profiles.R",    # raw read quality profile plots
  "R/03_primer_removal.R",      # cutadapt primer trimming
  "R/04_filter_trim.R",         # automatic trunclen + DADA2 filterAndTrim
  "R/05_learn_errors.R",        # DADA2 error model learning
  "R/06_denoise_merge.R",       # DADA2 denoising + pair merging
  "R/07_chimera_length_filter.R", # chimera removal + ASV length filter
  "R/08_read_tracking.R",       # reads-remaining-per-step summary table
  "R/09_taxonomy.R",            # SILVA taxonomy assignment (local database)
  "R/10_phyloseq_build.R",      # phyloseq object + contaminant/SSU filtering
  "R/11_phylogenetic_tree.R",   # DECIPHER + phangorn ML tree
  "R/12_rarefaction.R",         # rarefaction curves + rarefied phyloseq object
  "R/13_alpha_diversity.R",     # Observed, Chao1, Shannon, Simpson
  "R/14_beta_diversity.R",      # Bray-Curtis / UniFrac, PCoA, PERMANOVA, betadisper
  "R/15_relative_abundance.R",  # Phylum + Genus relative abundance barplots
  "R/16_ancombc.R"              # Differential abundance analysis
  )

for (script in stage_scripts) {
  message("\n================================================================")
  message("Running: ", script)
  message("================================================================")
  source(script)
}

message("\nPipeline finished. See results/tables, results/figures, and results/rds.")
