
DSC_HCStream <- function(wSize, gridSize, corePoints, m, k) {
  structure(list(description = "HCStream description",
                 RObj = hcStream_refClass$new(
                   wSize = wSize, gridSize = gridSize, corePoints = corePoints,
                   m = m, k = k)),
            class = c("DSC_HCStream","DSC_Micro","DSC_Micro","DSC_R","DSC"))
}


hcStream_refClass <- setRefClass("hcStream", 
                                      fields = list(
                                        wSize         = "numeric",
                                        gridSize      = "numeric",
                                        corePoints    = "numeric",
                                        m       = "numeric",
                                        k     = "numeric",
                                        
                                        startPos      = "numeric",

                                        assignment  = "numeric",
                                        data      = "data.frame",
                                        centers = "data.frame",
                                        weights	    = "numeric",
                                        clusterCenters = "data.frame",
                                        clusterWeights = "numeric",
                                        
                                        micro 		      = "ANY"
       
                                      ), 
                                      
                                      methods = list(
                                        initialize = function(
                                          wSize,
                                          gridSize,
                                          corePoints,
                                          m,
                                          k
                                        ) {
                                          wSize <<- wSize
                                          gridSize <<- gridSize
                                          corePoints	<<- corePoints
                                          m	<<- m
                                          k   <<- k
                                          
                                          startPos <<- 0
                                          
                                          assignment	<<- numeric()
                                          centers <<- data.frame()
                                          weights	<<- numeric() 
                                          clusterWeights <<- numeric() 
                                          clusterCenters <<- data.frame()
                                          data	<<- data.frame()
                                          
                                          micro <<- new(HCStream, wSize, gridSize, corePoints, m, k)
                                          
                                          .self
                                        }
                                        
                                      )
)

hcStream_refClass$methods(
  cluster = function(x, weight = rep(1, nrow(x)), ...) {
    
    print(paste("startPos", startPos, sep = " "))
    
    micro$cluster(startPos, as.matrix(x))
    clustNo = micro$getMacroClusterNo()
    
    #m = matrix( rep.int(0, clustNo * 2), nrow=clustNo, ncol=2, byrow = TRUE)
    # changed in FINAL version
    m = matrix( rep.int(0, clustNo * 2), nrow=clustNo, ncol=2, byrow = TRUE)
    #print(m)
    
    centers <<- as.data.frame(m)
    weights <<- rep(1, clustNo)
   
    clusterCenters <<- as.data.frame(m)
    clusterWeights <<- rep(1, clustNo)
    
    startPos <<- startPos + wSize
  },
  
  get_macroclusters = function(...) {
    #print("get_macroclusters")
    clusterCenters
  },
  
  get_macroweights = function(...) {
    #print("get_macroweights")
    clusterWeights
  },
  
  get_microclusters = function(...) {
    #print("get_microclusters")
    #print(centers)
    centers
  },
  
  get_microweights = function(x) {
    #print("get_microweights")
    weights
  },
  
  microToMacro = function(micro=NULL, ...){ 
    print("microToMacro")
    assignment <<- micro$getLabels(as.matrix(x))
    #print(assignment)
    assignment
  }
  
)


get_assignment.DSC_HCStream <- function(dsc, points, ...) {
  #print( dsc$RObj$micro$getLabels(as.matrix(points)) )
  assignment = dsc$RObj$micro$getLabels(as.matrix(points))
  dsc$RObj$assignment = assignment
  assignment
}

plot.DSC_HCStream <- function(dsc, dsd=NULL, n=500, 
                              type=c("micro", "macro", "both"), 
                              grid=FALSE, grid_type="used", assignment=FALSE,
                              ...) {
  
  
  #print("plot")
  xMin = -2.5 #dsc$RObj$dimRanges[1,1]
  xMax = 5 #dsc$RObj$dimRanges[1,2]
  yMin = -2.5 #dsc$RObj$dimRanges[2,1]
  yMax = 5 #dsc$RObj$dimRanges[2,2]
  
  xMin = 0 #dsc$RObj$dimRanges[1,1]
  xMax = 10 #dsc$RObj$dimRanges[1,2]
  yMin = 0 #dsc$RObj$dimRanges[2,1]
  yMax = 10 #dsc$RObj$dimRanges[2,2]

  
  #stepNo = dsc$RObj$stepNo
  #xStepVal = (xMax - xMin) / stepNo
  #yStepVal = (yMax - yMin) / stepNo
  
  plot(xMin:xMax, yMin:yMax, type = "n", main = list(...)$main)
  
  #abline(h=(seq(yMin, yMax, yStepVal)), col="gray", lty="dotted")
  #abline(v=(seq(xMin, xMax, xStepVal)), col="gray", lty="dotted")
  
  ps = get_points(dsd, n = n)
  assignment = dsc$RObj$assignment
  
  #print(assignment)

  points(ps, col = assignment + 2)
}
