library("stream")
library("streamMOA")
library(hcstream)
source("DSC_HCStream.R")

source("benchmark_extract_utils.R")
source("benchmark_comparison_utils_final.R")
source("benchmark_algs_utils_final.R")
source("benchmark_plot_utils.R")

# KDDCUP99 NETWORK INTRUSION DETECTION DATASET
# 24 attack types + non attack
# continuous attributes: 1, 5, 6, 8:11, 13:20, 23:41
ds.props <- new.env()
ds.props$ds = "kddcup99"
ds.props$fbase = "~/Desktop/benchmarks/datasets/kddcup99/"
ds.props$dsFile = "kddcup99.data.gz"
ds.props$dataCols = c(1, 5, 6, 8:11, 13:20, 23:41)
ds.props$labelCol = 42
ds.props$k = 25
ds.props$entryNo = 4898430
ds.props$wSize = 1000
ds.props$topNo = 150 # only 16 from 150 meet minLabelNo criteria
ds.props$wPadding = 3
ds.props$minLabelNo = 3 

#ds.props$measures = c("numClasses", "numMicroClusters", "numMacroClusters", "purity", "cRand", "NMI", "precision", "Rand")

#ds.props$measures = c("numMicroClusters", "numMacroClusters", "purity", "cRand", "NMI", "precision", "Rand")
ds.props$measures = c("numMicroClusters","numMacroClusters", "purity", "Rand")

#type - Use micro- or macro-clusters for evaluation. Auto used the class of dsc to decide.
#assign - Assign points to micro or macro-clusters?

# D-Stream : type="macro", assign="micro",

ds.props$algAssign <- list(
  "D-Stream" = "micro",
  "CluStream" = "micro",
  "DenStream" = "micro",
  "BloomStream" = "macro"
)
ds.props$algType <- list(
  # "D-Stream" = "micro", original
  "D-Stream" = "macro", # micro
  "CluStream" = "macro", # micro
  "DenStream" = "macro", # micro
  "BloomStream" = "macro" # macro
)

ds.props$streamScale <- list(
  # "D-Stream" = TRUE, original
  "D-Stream" = TRUE,
  "CluStream" = TRUE,
  "DenStream" = TRUE,
  "BloomStream" = TRUE
)

#1 scan and save most interesting windows
#saveTopWindows()

#2 create separate file with each window interval
#ds.props$top.windows = loadTopWindows()
#genTopRows()

#3 compare algorithms against each window interval
#compareAlgorithms()

#compareAlgorithm(2)

#4 plot algorithm comparison evaluation
#topIdxs = c(2,3,5,8,10) # c(1,2,3,4,5)
#topIdxs = c(1,2,3,4,5,6,7,8,9,10) # c(1,2,3,4,5)

# top 8 rand : 7,6, 46,45, 12,13, 2,13
# top 4 rand: 149, 76, 86, 55

# top purity bloom: 12, 3, 2, 10
# top rand bloom: 2, 13, 6, 14 | 13  2  1 11 |
topIdxs = c(1, 2, 4, 6, 7, 13) # 7,6,  1,7,  13,4,   13,2
#topIdxs = c(7,1,  13, 2) # 7,6,  1,7,  13,4,   13,2
plotEvaluation(allIdxs = c(1:14), topIdxs = topIdxs, measure = "Rand")

# "purity", "cRand", "NMI", "precision", "Rand")

#"numClasses", "numMicroClusters", "numMacroClusters", NMI

# "classNo","winNo","labels"
# 7,"4000","1-26, 2-21, 3-185, 4-536, 5-77, 6-138, 7-17"
# 7,"5000","1-26, 2-25, 3-229, 4-287, 5-31, 6-341, 7-61"
# 7,"6000","1-142, 2-123, 3-140, 4-84, 5-185, 6-246, 7-80"
# 7,"12000","1-27, 2-40, 3-188, 4-427, 5-145, 6-146, 7-27"
# 7,"13000","1-95, 2-74, 3-178, 4-113, 5-143, 6-245, 7-152"
# 7,"233000","1-220, 2-523, 3-99, 4-2, 5-20, 6-74, 7-62"
# 7,"234000","1-253, 2-490, 3-90, 4-3, 5-22, 6-72, 7-70"
# 7,"235000","1-290, 2-453, 3-60, 4-3, 5-22, 6-94, 7-78"
# 7,"237000","1-204, 2-494, 3-85, 4-1, 5-44, 6-168, 7-4"
# 7,"248000","1-62, 2-519, 3-271, 4-1, 5-39, 6-94, 7-14"
