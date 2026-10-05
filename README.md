# Automated Microbiome R pipeline

A reproducible and automated R pipeline for end-to-end analysis of bacterial 16S rRNA amplicon sequencing data.

---

## Features

- Runs the complete DADA2 workflow from raw FASTQ files to final results.
- Performs ASV inference with DADA2 and taxonomic assignment using SILVA.
- Automatically determines read truncation lengths from sequencing quality.
- Supports automatic rarefaction depth selection.
- Performs diversity analyses with Wilcoxon, Kruskal–Wallis, PERMANOVA, and related tests.
- Automatically generates and saves all analysis results, figures, and tables.
- Saves intermediate results so interrupted analyses can be resumed.

---

## Quick Start

Follow the steps below to run the pipeline.

### Step 1. Download the pipeline

Clone the repository:

```bash
git clone https://github.com/grace-hoang/Automated-Microbiome-R-Pipeline.git
```

Alternatively, download the repository as a ZIP file from GitHub and extract it.

Open **R** or **RStudio**, then set the working directory to the `Automated-Microbiome-R-Pipeline` folder.

---

### Step 2. Install dependencies

Install all required R packages:

```r
source("R/00_install_packages.R")
```

This script automatically checks your system and installs any missing CRAN and Bioconductor packages.

Primer removal requires **Cutadapt**. Install it using either:

**pip**

```bash
pip install cutadapt
```

or **conda**

```bash
conda install -c bioconda cutadapt
```

---

### Step 3. Prepare your project directory

Download the **SILVA v138.2 DADA2 training set**:

```text
silva_nr99_v138.2_toGenus_trainset.fa.gz
```

Create a metadata file (`metadata.csv`) containing one row per sample. The `SampleID` column must exactly match the sample names in the FASTQ files. Additional columns may be included for downstream analyses (e.g., treatment, habitat, location, or sampling time).

Example:

```text
SampleID,Group,Location
Sample1,Control,SiteA
Sample2,Treatment,SiteA
Sample3,Control,SiteB
Sample4,Treatment,SiteB
```

Organize your project directory as follows:

```text
My_Project/
│
├── fastqs/
│   ├── Sample1_R1.fastq.gz
│   ├── Sample1_R2.fastq.gz
│   └── ...
│
├── metadata.csv
│
└── Silva/
    └── silva_nr99_v138.2_toGenus_trainset.fa.gz
```

---

### Step 4. Configure the pipeline

Open:

```text
R/00_parameters.R
```

Modify the project-specific parameters, including input paths, metadata, taxonomy database, filtering options, and analysis settings.

---

### Step 5. Run the pipeline

Execute the complete workflow:

```r
source("main.R")
```

All outputs are automatically saved to:

```text
results/
├── figures/
├── tables/
├── rds/
└── logs/
```

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

## Resume Interrupted Runs

Intermediate results are automatically saved as `.rds` files.

If the pipeline is interrupted, completed steps are loaded from these files instead of being recomputed, allowing the analysis to resume from the last completed stage.

To rerun the entire workflow from scratch, set

```r
FORCE_RERUN <- TRUE
```

in `R/00_parameters.R`.
