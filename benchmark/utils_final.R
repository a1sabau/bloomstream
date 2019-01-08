require(stats)


doCluster <- function(stream, k, winLearnSize, winEvalSize) {

  resultSep = "---\n"

  # 2 stage clustree
  CTxReach <- DSC_TwoStage(
    micro=DSC_ClusTree(maxHeight=3, horizon = winLearnSize),
    macro=DSC_Reachability(epsilon = 0.3)
  )
  
  
  
#   gs2 = 2 / (k + 5)
#   mu2 = winLearnSize / (k  * (dimNo * dimNo))
#   
#   avgDensity = winLearnSize / ((1/0.5)^dimNo)
#   print("avgDensity")
#   print(avgDensity)
#   cm = 3 / avgDensity
#   print("cm")
#   print(cm)
#   N = k * (2^dimNo)
#   print(N)
#   
#   print("gs")
#   print(gs2)
#   print("mu2")
#   print(mu2)
  
  gs = 1.5
  mu = 5
  
  algorithms <- list(
    "CluStream" = DSC_CluStream(m = k * 10, horizon = winLearnSize, k = k),
    #"DenStream" = DSC_DenStream(epsilon = 0.5, mu = mu, initPoints = 200),  #initPoints = 100
    "D-Stream" = DSC_DStream(gridsize = gs, gaptime = winLearnSize),
    "HCStream" = DSC_HCStream(wSize = winLearnSize, gridSize = gs, corePoints = mu, m = 5003, k = 7) #3847
  )

  
  
  measures = c("precision", "Rand", "purity", "crand", "FM", "Jaccard", "NMI")
  
  result = sapply(algorithms, FUN=function(a) {
    # reset stream for each algorithm
    print("reset stream")
    reset_stream(stream)
    
    # elapsed time for parsing stream (online phase)
    tUpdate = system.time(update(a, stream, n = winLearnSize))
    
    # number of clusters
    microNo = nclusters(a, type = "micro")
    macroNo = nclusters(a, type = "macro")
    
    # quality measures
    tEval = system.time( r <- evaluate(a, stream, measure = measures, assign = "macro", type= "macro", n = winEvalSize) )
    r["microNo"] = microNo
    r["macroNo"] = macroNo
    r["elapsed_update"] = tUpdate["elapsed"]
    r["elapsed_eval"] = tEval["elapsed"]
    r["elapsed_total"] =  tUpdate["elapsed"] + tEval["elapsed"]

    
    
    
    
    if (TRUE && grepl("HCStream", a$description, ignore.case=TRUE)) {
      reset_stream(stream, pos = winLearnSize + 1)
      #plot(a, stream, main = a$description, type = "both", n = 50, dim=c(1,2) )
      #plot(stream, n = 1000, dim=c(1,2) )
      #print("plot done")
    }
    
    r
  })
  print(result)
}