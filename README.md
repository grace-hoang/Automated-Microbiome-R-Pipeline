# 

A reproducible, modular, and automated R pipeline for analyzing bacterial 16S rRNA amplicon sequencing data using the DADA2 workflow.

The pipeline performs end-to-end microbiome analysis, including quality control, ASV inference, taxonomic assignment, phylogenetic tree construction, diversity analysis, differential abundance testing, and publication-ready visualization.

---

## Features

- Fully implemented in native R
- Modular workflow with independent scripts
- Automatic quality filtering and truncation length selection
- DADA2 ASV inference
- SILVA taxonomic assignment
- Phyloseq object construction
- Phylogenetic tree generation
- Alpha and beta diversity analyses
- Relative abundance visualization
- ANCOM-BC differential abundance analysis
- Intermediate object caching for workflow resumption
- Publication-ready figures and tables

---

## Requirements

### R

R ≥ 4.3

### External software

Primer removal requires **cutadapt**.

Install using pip

```bash
pip install cutadapt
```

or conda

```bash
conda install -c bioconda cutadapt
```

---

## Installation

### Install all required R packages by running

```r
source("00_install_packages.R")
```

This script only installs missing packages.

### Download the SILVA reference database

This pipeline uses the **SILVA v138.2 DADA2 training set** for taxonomic assignment.

Download:

```
silva_nr99_v138.2_toGenus_trainset.fa.gz
```

Place the file in:

```text
project_dir/
└── Silva/
    └── silva_nr99_v138.2_toGenus_trainset.fa.gz
```

---

## Configuration

All user-editable parameters are stored in

```text
R/00_parameters.R
```

This file contains all user-configurable settings, including:

- **General pipeline options** 
- **Project directory** (`project_dir`)
- **FASTQ input folders** (`fastq_dirs`)
- **Sample metadata** (`group_column`, `group_levels`, `reference_group`)
- **SILVA taxonomy reference** (`silva_ref_path`)
- **Primer sequences** (`primer_fwd`, `primer_rev`)
- **DADA2 parameters** 
- **Taxonomic filtering** 
- **Rarefaction settings** 
- **Alpha and beta diversity settings**
- **Relative abundance thresholds**
- **Output directories**

For most users, only the following parameters typically need to be modified:

- `project_dir`
- `fastq_dirs`
- `group_column`
- `group_levels`
- `reference_group`
- `silva_ref_path`
- `primer_fwd`
- `primer_rev`

The remaining parameters can usually be left at their default values unless a different analysis strategy is required.

---

## Set the working directory

Before running the pipeline, set the working directory to the folder containing the pipeline files.

Example:

```r
setwd("C:/Users/Grace_Hoang/OneDrive/Desktop/bioinfor/R_pipeline")
```

---

## Running the pipeline

Run the complete workflow

```r
source("main.R")
```

or execute individual modules independently.

For example

```r
source("R/13_alpha_diversity.R")
```

When running individual scripts, first load

```r
source("R/00_parameters.R")
source("R/01_helper_functions.R")
```

and ensure the required intermediate `.rds` files have been generated.

---

## Workflow

1. Helper functions
2. Quality profiles
3. Primer removal
4. Read filtering and trimming
5. Error model learning
6. Denoise and merge
7. Chimera removal
8. Read tracking
9. Taxonomic assignment
10. Phyloseq object construction
11. Phylogenetic tree construction
12. Rarefaction
13. Alpha diversity
14. Beta diversity
15. Relative abundance analysis
16. Differential abundance analysis (ANCOM-BC)

---

## Output structure

```
results/
│
├── figures/
├── tables/
├── rds/
└── logs/
```

---

## Pipeline stages

| Script | Description | Main output |
|---------|-------------|-------------|
| `02_quality_profiles.R` | Quality assessment | Raw quality plots |
| `03_primer_removal.R` | Primer trimming | Trimmed FASTQ files |
| `04_filter_trim.R` | Quality filtering | Filter summary |
| `05_learn_errors.R` | Error learning | Error model plots |
| `06_denoise_merge.R` | ASV inference | ASV table |
| `07_chimera_length_filter.R` | Chimera removal | Filtered ASV table |
| `08_read_tracking.R` | Read retention | `read_tracking.csv` |
| `09_taxonomy.R` | Taxonomic assignment | `taxonomy.csv` |
| `10_phyloseq_build.R` | Phyloseq construction | `physeq.rds` |
| `11_phylogenetic_tree.R` | Tree construction | ML phylogenetic tree |
| `12_rarefaction.R` | Rarefaction | Rarefied phyloseq object |
| `13_alpha_diversity.R` | Alpha diversity | Diversity tables and plots |
| `14_beta_diversity.R` | Beta diversity | PCoA and PERMANOVA |
| `15_relative_abundance.R` | Taxonomic composition | Relative abundance plots |
| `16_ancombc.R` | Differential abundance | ANCOM-BC results |

---

## Reproducibility

Intermediate results are automatically cached as `.rds` objects.

If the pipeline is interrupted, completed stages are loaded from cache rather than recomputed.

To rerun the complete workflow, set

```r
FORCE_RERUN <- TRUE
```

in

```text
R/00_parameters.R
```


