library("streamMOA")
library(stream)
library(hcstream)
source("utils_final.R")
source("DSC_HCStream.R")
#source("algorithms.R")

# disable scientific notation
#options(scipen=8)
options("scipen"=100, "digits"=4)

dimNo = 5
k = 5
winSize = 128 * 1000  # 2, 4, 8, 16, 32, 64, 128 
clustSep = 4

centers = matrix(0L, nrow = k, ncol = dimNo)
for (i in 1:k) {
  for (j in 1:dimNo) {
    centers[i,j]=i * clustSep
  }
}
#print("centers")
#print(centers)
maxVal = (k+1)*clustSep

noise_range = matrix(0L, nrow = dimNo, ncol = 2)
for (i in 1:dimNo) {
  noise_range[i,1]=0
  noise_range[i,2]=maxVal
}
#print("noise_range")
#print(noise_range)

scale = rep(maxVal, dimNo)
#print("scale")
#print(scale)

# first parse wSize * 2, then parse wSize * 2 and get labels for the last part
winLearnSize = winSize
winEvalSize = winSize

# generate gaussians
gaussStream <- DSD_Gaussians(k = k, d = dimNo, mu=centers, noise = .05, noise_range = noise_range)
#gaussStream <- DSD_Gaussians(k = k, d = dimNo, mu=centers)


# normalize data
#scaledStream <- DSD_ScaleStream(gaussStream, center = FALSE, scale = scale, reset=TRUE, n=2000)
# store in memory so we can reset and use exact same points with each clustering algorithm
stream <- DSD_Memory(gaussStream, n = winLearnSize + winEvalSize)

print("startCluster")
doCluster(stream = stream, k = k, winLearnSize = winLearnSize, winEvalSize = winEvalSize)

print("done")