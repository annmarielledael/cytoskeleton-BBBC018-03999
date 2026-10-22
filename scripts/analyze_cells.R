# Cytoskeleton and Cell Morphology
# BBBC018 - Image field 03999

phenotype <- "Peripheral actin"
image_id <- "03999"

# Read the Fiji measurements
d <- read.csv("cytoskeleton-BBBC018/data/fiji_results.csv.csv",
              check.names = FALSE)

# Check that the required columns exist
needed <- c("Area", "Mean", "Circ.", "AR")
if (!all(needed %in% names(d))) {
  stop("Missing Fiji columns. Check your Fiji measurements.")
}

d <- d[complete.cases(d[, needed]), ]

if (nrow(d) < 5) {
  stop("Please measure five clear cells in Fiji.")
}

d$Cell <- paste0("Cell ", seq_len(nrow(d)))

# Create output folders
dir.create("results", showWarnings = FALSE)
dir.create("figures", showWarnings = FALSE)

# Calculate summary statistics
summary_data <- data.frame(
  phenotype = phenotype,
  image_id = image_id,
  cells_measured = nrow(d),
  mean_area_px2 = mean(d$Area),
  mean_circularity = mean(d[["Circ."]]),
  mean_aspect_ratio = mean(d$AR),
  mean_actin_signal = mean(d$Mean)
)

write.csv(
  summary_data,
  "results/cell_summary.csv",
  row.names = FALSE
)

print(summary_data)

# Figure 1: Area vs. Circularity
png("cytoskeleton-BBBC018/figures/area_vs_circularity.png",
    width = 900, height = 650)

plot(
  d$Area,
  d[["Circ."]],
  pch = 19,
  xlab = "Cell area (pixels squared)",
  ylab = "Circularity (0 to 1)",
  main = paste(phenotype, "-", image_id)
)

dev.off()

# Figure 2: Mean actin fluorescence per cell
png("figures/actin_intensity.png",
    width = 900, height = 650)

barplot(
  d$Mean,
  names.arg = d$Cell,
  ylab = "Mean actin fluorescence (arbitrary units)",
  main = paste("Actin signal -", image_id)
)

dev.off()