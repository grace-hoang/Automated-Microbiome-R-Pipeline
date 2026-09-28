# 10. BUILD THE PHYLOSEQ OBJECT
# Combines ASV table, taxonomy table, and metadata

suppressPackageStartupMessages({
  library(phyloseq)
  library(Biostrings)
})

seqtab_final <- readRDS(file.path(dir_rds, "seqtab_final.rds"))
taxonomy     <- readRDS(file.path(dir_rds, "taxonomy.rds"))
fastq_info   <- readRDS(file.path(dir_rds, "fastq_info.rds"))

physeq <- load_or_compute(
  file.path(dir_rds, "physeq.rds"),
  function() {
    
    sample_data_df <- fastq_info
    rownames(sample_data_df) <- sample_data_df$SampleID
    
    physeq_raw <- phyloseq(
      otu_table(seqtab_final, taxa_are_rows = FALSE),
      tax_table(taxonomy),
      sample_data(sample_data_df)
    )
    
    # Keep original ASV sequences before renaming taxa
    asv_sequences <- DNAStringSet(taxa_names(physeq_raw))
    names(asv_sequences) <- paste0("ASV", seq_along(asv_sequences))
    
    taxa_names(physeq_raw) <- names(asv_sequences)
    physeq_raw <- merge_phyloseq(physeq_raw, asv_sequences)
    
    writeXStringSet(
      asv_sequences,
      file.path(dir_tables, "asv_sequences.fasta")
    )
    
    # Taxonomic filtering
    tax_df <- as.data.frame(tax_table(physeq_raw))
    
    keep <- rep(TRUE, nrow(tax_df))
    
    if (remove_unassigned)
      keep <- keep & !is.na(tax_df$Kingdom)
    
    if (remove_chloroplast)
      keep <- keep & (is.na(tax_df$Order) |
                        tax_df$Order != "Chloroplast")
    
    if (remove_mitochondria)
      keep <- keep & (is.na(tax_df$Family) |
                        tax_df$Family != "Mitochondria")
    
    keep <- keep & tax_df$Kingdom %in% target_kingdoms
    
    message(
      sum(keep), " of ",
      length(keep),
      " ASVs kept after taxonomic filtering"
    )
    
    prune_taxa(keep, physeq_raw)
    
  },
  params = list(
    remove_unassigned   = remove_unassigned,
    remove_chloroplast  = remove_chloroplast,
    remove_mitochondria = remove_mitochondria,
    target_kingdoms     = target_kingdoms
  ),
  depends_on = c(
    file.path(dir_rds, "seqtab_final.rds"),
    file.path(dir_rds, "taxonomy.rds"),
    file.path(dir_rds, "fastq_info.rds")
  )
)