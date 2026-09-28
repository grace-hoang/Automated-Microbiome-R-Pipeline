# Run this script once before using the pipeline
# Install BiocManager
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

# Required CRAN packages
cran_pkgs <- c(
  "tidyverse",
  "vegan",
  "Polychrome"
)

# Required Bioconductor packages
bioc_pkgs <- c(
  "dada2",
  "phyloseq",
  "ShortRead",
  "Biostrings",
  "DECIPHER",
  "phangorn",
  "ANCOMBC"
)

# Identify missing CRAN packages
to_install_cran <- setdiff(cran_pkgs, rownames(installed.packages()))

# Install missing CRAN packages
if (length(to_install_cran) > 0)
  install.packages(to_install_cran)

# Identify missing Bioconductor packages
to_install_bioc <- setdiff(bioc_pkgs, rownames(installed.packages()))

# Install missing Bioconductor packages
if (length(to_install_bioc) > 0)
  BiocManager::install(to_install_bioc, update = FALSE)

message("All packages installed.")
