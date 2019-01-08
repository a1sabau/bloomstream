initAlgs = function() {
  algs = list()
  
  if (ds.props$ds == "kddcup99_old") {
    print("init algorithms for kddcup99")
    # k = 25
    algs = list(
      "D-Stream" = DSC_DStream(gaptime = ds.props$wSize, gridsize = 0.05, lambda = -0.00288, epsilon = 0.3, Cm = 3.0, Cl = 0.8),
      "CluStream" = DSC_CluStream(m = ds.props$k * 10, horizon = ds.props$wSize, k = ds.props$k), # t = 2
      "DenStream" = DSC_DenStream(lambda = 0.001, epsilon = 1, mu = 1, beta = 0.2, processingSpeed = 1, initPoints = ds.props$wSize, offline = 2),
      
      "BloomStream" = DSC_HCStream(wSize = ds.props$wSize, gridSize = 0.05, corePoints = 5, cmDelta = 0.005, cmEpsilon = 0.005)
    )
  }
  
  if (ds.props$ds == "kddcup99_old2") {
    print("init algorithms for kddcup99")
    # k = 25
    
    
    algs = list(
      "D-Stream" = DSC_DStream(gaptime = ds.props$wSize, gridsize = 3, Cm = 2), # FINAL
      "CluStream" = DSC_CluStream(m = ds.props$k * 10, horizon = ds.props$wSize, k = ds.props$k), # CORRECT
      "DenStream" = DSC_DenStream(epsilon = 0.6, mu = 2, initPoints = ds.props$wSize), # CORRECT
      "BloomStream" = DSC_HCStream(wSize = ds.props$wSize, gridSize = 1.8, corePoints = 3, m = 15013, k = 7) # CORRECT
    )
  }
  
  if (ds.props$ds == "kddcup99") {
    print("init algorithms for kddcup99")
    # k = 25
  
    # used in D-Stream : 0.05
    gs = 3.5 #3.5
    mu = 4
    
    algs = list(
      "D-Stream" = DSC_DStream(gaptime = ds.props$wSize, gridsize = gs, Cm = 3), # FINAL
      "CluStream" = DSC_CluStream(m = ds.props$k * 10, horizon = ds.props$wSize, k = ds.props$k), # CORRECT
      "DenStream" = DSC_DenStream(epsilon = 0.6, mu = mu, initPoints = 1000), #ds.props$wSize) # CORRECT
      "BloomStream" = DSC_HCStream(wSize = ds.props$wSize, gridSize = gs, corePoints = mu, m = 15013, k = 7) # CORRECT
    )
  }
  
  if (ds.props$ds == "covertype") {
    print("init algorithms for covertype")
    # k = 7
    algs = list(
      #"D-Stream" = DSC_DStream(gaptime = ds.props$wSize, gridsize = 0.05, lambda = -0.00288, epsilon = 0.2, Cm = 3.0, Cl = 0.8)
      "D-Stream" = DSC_DStream(gaptime = ds.props$wSize, gridsize = 1.2, Cm = 3.0), # FINAL
                               #attraction = TRUE,
                               #lambda = -0.00288, 
                               #epsilon = 0.2, Cm = 3.0, Cl = 0.8)
      
      #"D-Stream" = DSC_DStream(gaptime = ds.props$wSize, gridsize = 1.7, 
      #attraction = TRUE,
      #lambda = -0.00288, 
      #epsilon = 0.2, Cm = 2.0, Cl = 0.8)
      
      #"CluStream" = DSC_CluStream(m = ds.props$k * 100, horizon = ds.props$wSize, k = ds.props$k, t = 2)
      "CluStream" = DSC_CluStream(m = ds.props$k * 10, horizon = ds.props$wSize, k = ds.props$k), # CORRECT
      
      #"DenStream" = DSC_DenStream(lambda = 0.001, epsilon = 1, mu = 1, beta = 0.2, processingSpeed = 1, initPoints = ds.props$wSize, offline = 2),
      "DenStream" = DSC_DenStream(epsilon = 0.8, mu = 15, initPoints = ds.props$wSize), # CORRECT
      
      "BloomStream" = DSC_HCStream(wSize = ds.props$wSize, gridSize = 1.5, corePoints = 3, m = 5003, k = 7) # CORRECT
      #DSC_HCStream(wSize = winLearnSize, gridSize = 1.5, corePoints = mu, m = 5003, k = 7) 
    )
  }
  
  algs
}

rawAlgs_Unused = function() {
  algorithms <- list(
    # R default: DSC_DStream(gridsize, lambda = 1e-3, gaptime=1000L, Cm=3, Cl=.8, attraction=FALSE, epsilon=.3, Cm2=Cm, k=NULL, N = 0)
    # article default: Cm = 3.0, Cl = 0.8, lambda = 0.998, and beta = 0.3, len = 0.05
    # prev DSC_DStream(gridsize = .5, gaptime = wSize, lambda = .01)
    # lambda: 0.001 (R default) vs 0.998 (article)
    # beta: constructor uses epsilon
    
    # lambda = 0.998 from article (decay factor)
    # lambda for R = 2^(-lambda) = 0.998, lambda = -0.00288 ~= 1e-3
    "D-Stream" = DSC_DStream(gaptime = wSize, gridsize = 0.05, lambda = -0.00288, epsilon = 0.3, Cm = 3.0, Cl = 0.8),
    
    # R default: m = 100, horizon = 1000, t = 2, k=NULL
    # article default: alpha = 2, l = 10, InitNumber = 2000, delta = 512, and t = 2.
    "CluStream" = DSC_CluStream(m = k * 10, horizon = wSize, k = k, t = 2),
    
    
    # R default: epsilon, mu = 1, beta = 0.2, lambda = 0.001, initPoints = 100, offline = 2, processingSpeed=1, recluster = TRUE, k=NULL
    # article default: InitN = 1000, stream speed v = 1000, decay factor lambda = 0.25, epsilon = 16, mu = 10, outlier threshold beta = 0:2.
    
    # horizon no longer taken into account
    # lambda based on MOA, http://code.google.com/p/moa/ , http://code.google.com/p/moa/source/browse/moa/src/main/java/moa/clusterers/denstream/WithDBSCAN.java
    # private double weightThreshold = 0.01;
    # horizon = wSize = 2000;
    # lambda = -Math.log(weightThreshold) / Math.log(2)/(double) horizonOption.getValue();
    # lambda = -Math.log(0.01) / Math.log(2) / 2000
    # lambda = -(-2) / 0.301 / 2000 = 0,0033
    # in prev MOA, lambda was hard coded at 0,0033 
    # in newest MOA, lambda = lambdaOption.getValue();
    
    #"DenStream" = DSC_DenStream(lambda = 0.25, epsilon = 1, mu = 1, beta = 0.2, processingSpeed = wSize, initPoints = wSize, offline = 16)
    "DenStream" = DSC_DenStream(lambda = 0.001, epsilon = 1, mu = 1, beta = 0.2, processingSpeed = 1, initPoints = wSize, offline = 2),
    
    "BloomStream" = DSC_HCStream(wSize = wSize, gridSize = 0.05, corePoints = 5, cmDelta = 0.005, cmEpsilon = 0.005)
  )
}

