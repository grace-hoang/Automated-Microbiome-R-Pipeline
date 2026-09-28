# 2. QUALITY PROFILES

suppressPackageStartupMessages({
  library(dada2)
  library(tidyverse)
})

# Find paired-end FASTQ files --------------------------------------------------

pattern_F <- "(_R1|_1)(_001)?\\.(fastq|fq)(\\.gz)?$"
pattern_R <- "(_R2|_2)(_001)?\\.(fastq|fq)(\\.gz)?$"

target_dirs <- project_dir

fnF <- sort(list.files(
  target_dirs,
  pattern = pattern_F,
  full.names = TRUE,
  recursive = TRUE
))

fnR <- sort(list.files(
  target_dirs,
  pattern = pattern_R,
  full.names = TRUE,
  recursive = TRUE
))

sample_names <- sub(pattern_F, "", basename(fnF))

if (!length(fnF) ||
    !identical(sample_names, sub(pattern_R, "", basename(fnR)))) {
  stop("FASTQ files not found or forward/reverse pairs do not match.")
}

# Load metadata ---------------------------------------------------------------

meta <- metadata
colnames(meta)[1] <- "SampleID"

# Check metadata --------------------------------------------------------------

if (anyDuplicated(meta$SampleID))
  stop("Duplicate SampleIDs found in metadata.csv.")

missing <- setdiff(sample_names, meta$SampleID)
if (length(missing))
  stop(
    "The following FASTQ samples are missing from metadata.csv:\n",
    paste(missing, collapse = ", ")
  )

# Combine FASTQ paths with metadata -------------------------------------------

fastq_info <- data.frame(
  SampleID = sample_names,
  fnF = fnF,
  fnR = fnR,
  stringsAsFactors = FALSE
) %>%
  inner_join(meta, by = "SampleID")

saveRDS(fastq_info, file.path(dir_rds, "fastq_info.rds"))

message(
  "Successfully matched ",
  nrow(fastq_info),
  " samples with metadata.csv."
)

# Plot quality profiles -------------------------------------------------------

save_plot(
  plotQualityProfile(fastq_info$fnF[1]) +
    ggtitle(paste("Forward:", fastq_info$SampleID[1])),
  "quality_profile_forward"
)

save_plot(
  plotQualityProfile(fastq_info$fnR[1]) +
    ggtitle(paste("Reverse:", fastq_info$SampleID[1])),
  "quality_profile_reverse"
)