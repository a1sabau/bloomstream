library("stream")
library(hcstream)
source("DSC_HCStream.R")

stream <- DSD_Memory(DSD_Benchmark(1), n = 5000)

algorithms <- list(
  "Sample" = DSC_TwoStage(micro = DSC_Sample(k = 100, biased = TRUE), macro = DSC_Kmeans(k = 2)),
  "Window" = DSC_TwoStage(micro = DSC_Window(horizon = 100, lambda = .01), macro = DSC_Kmeans(k = 2)),
  "D-Stream" = DSC_DStream(gridsize = .1, lambda = .01),
  "DBSTREAM" = DSC_DBSTREAM(r = .05, lambda = .01),
  "BloomStream" = DSC_HCStream(wSize = 100, gridSize = 0.1, corePoints = 5, cmDelta = 0.005, cmEpsilon = 0.005)
)

evaluation <- lapply(algorithms, FUN = function(a) {
  reset_stream(stream)
  #evaluate_cluster(a, stream, horizon = 100, n = 1000, measure = "crand", type = "macro", assign = "micro")
  evaluate_cluster(a, stream, horizon = 100, n = 5000, measure = "crand", type = "macro", assign = "macro")
})

print(evaluation[[1]])
Position <- evaluation[[1]][ , "points"]
cRand <- sapply(evaluation, FUN = function(x) x[ , "cRand"])
print(head(cRand))

matplot(Position, cRand, type = "l", lwd = 2)
legend("bottomleft", legend = names(evaluation), col = 1:6, lty = 1:6, bty = "n", lwd = 2)
#boxplot(cRand, las = 2, cex.axis = .8)

print("done")