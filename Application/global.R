
# Variables that can be put on the x and y axes
axis_vars <- c(
  
  "Mean frequency (in kHz)" = "meanfreq",
  "Standard deviation of frequency" = "sd",
  "Median frequency (in kHz)" = "median",
  "First quantile (in kHz)" = "Q25",
  "Third quantile (in kHz)" = "Q75",
  "Interquantile range (in kHz)" = "IQR",
  "Skewness" = "skew",
  "Kurtois" = "kurt",
  "Spectral entropy" = "sp.ent",
  "Spectral flatness"= "sfm",
  "Mode frequency" = "mode",
  "Frequency centroid" = "centroid",
  "Peak frequency (frequency with highest energy)" = "peakf",
  "Average of fundamental frequency measured across acoustic signal" = "meanfun",
  "Minimum fundamental frequency measured across acoustic signal" = "minfun",
  "Maximum fundamental frequency measured across acoustic signal" = "maxfun",
  "Average of dominant frequency measured across acoustic signal" = "meandom",
  "Minimum of dominant frequency measured across acoustic signal" = "mindom",
  "Maximum of dominant frequency measured across acoustic signal" = "maxdom",
  "Range of dominant frequency measured across acoustic signal" = "dfrange",
  "Modulation index" =  "modindx",
  "Label" = "label"
  
)

algorithms <-  c(
  "KNN" = "enable_KNN",
  "J48" = "enable_J48",
  "Random Forest" = "enable_RandomForest",
  "SVM" = "enable_SVM",
  "Naive Bayes" = "enable_NaiveBayes"
)
