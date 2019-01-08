getResult = function(idx) {
  fEval = paste(ds.props$fbase, "eval_wsize_", ds.props$wSize, "_topNo_", ds.props$topNo, "_idx_", idx, ".csv", sep = "")
  print(paste("reading file", fEval))
  df = read.csv(file = fEval, header = TRUE, check.names=FALSE)
  df
}

getStream = function(idx, algName) {
  dfFile = paste(ds.props$fbase, "df_wsize_", ds.props$wSize, "_topNo_", ds.props$topNo, "_idx_", idx, ".csv", sep = "")
  print(dfFile)
  cols = c(ds.props$dataCols, ds.props$labelCol)
  rawStream <- DSD_ReadCSV(dfFile, take = cols, class = ds.props$labelCol, k = ds.props$k)
  print("cols")
  print(cols)
  print(rawStream)
  
  streamScale = ds.props$streamScale[[algName]]
  if (streamScale == TRUE) {
    stream = DSD_ScaleStream(rawStream, n=7000, reset=TRUE)
  }
  else {
    stream = rawStream
  }
  
  print(paste("preparing stream", dfFile, ", scale:", streamScale, "... DONE"))
  stream
}

compareAlgorithms = function() {
  for (idx in 1:ds.props$topNo) {
    print(paste("preparing evaluation", idx, "from", ds.props$topNo))
    
    # compare algs against stream
    algs = initAlgs()
    entryNo = (2 * ds.props$wPadding + 1) * ds.props$wSize
    evaluation = compareTimeUnit(algs, idx, entryNo)
    fEval = paste(ds.props$fbase, "eval_wsize_", ds.props$wSize, "_topNo_", ds.props$topNo, "_idx_", idx, ".csv", sep = "")
    write.table(evaluation, file = fEval, append = FALSE, sep = ",", col.names = TRUE, row.names = FALSE)
  }
}

compareAlgorithm = function(idx) {
    print(paste("preparing evaluation", idx, "from", ds.props$topNo))
    
    # compare algs against stream
    algs = initAlgs()
    entryNo = (2 * ds.props$wPadding + 1) * ds.props$wSize
    evaluation = compareTimeUnit(algs, idx, entryNo)
    fEval = paste(ds.props$fbase, "eval_wsize_", ds.props$wSize, "_topNo_", ds.props$topNo, "_idx_", idx, ".csv", sep = "")
    #print(fEval)
    #write.table(evaluation, file = fEval, append = FALSE, sep = ",", col.names = TRUE, row.names = FALSE)
    
    print(evaluation)
}

compareTimeUnit = function(algs, topIdx, entryNo) {
  
  evaluation <- lapply(seq_along(algs), function(alg, name, i) {
    algName = name[[i]]
    
    # reset stream for each algorithm
    stream = getStream(topIdx, algName)
    
    # init params for each algorithm
    algAssign = ds.props$algAssign[[algName]]
    algType = ds.props$algType[[algName]]
    streamScale = ds.props$streamScale[[algName]]
    print(paste("evaluating algorithm", algName, ", assignment:", algAssign, ", type:", algType, ", entryNo:", entryNo))
    
    # evaluate alg
    r <- evaluate_cluster(dsc = alg[[i]], dsd = stream, measure = ds.props$measures, n = entryNo, horizon = ds.props$wSize, type = algType, assign = algAssign)
    print(paste("completed evaluation for algorithm", algName))

    
    reset_stream(stream)
    print(stream)
    points <- get_points(stream, n = 5)
    print(points)
    assignment <- get_assignment(alg[[i]], points, type = "macro")
    print("assignment start")
    print(assignment)
    print("assignment end")
    
    r
  }, alg=algs, name=names(algs))
  
  formatEvaluation(evaluation, algs)
}

formatEvaluation = function(evaluation, algs) {
  df <- data.frame( "points" = evaluation[[1]][ , "points"])
  
  for (i in 1:length(evaluation)) {
    item = evaluation[[i]]
    key = names(algs)[i]
    
    algDf = data.frame(item[, ds.props$measures])
    for (k in 1:length(ds.props$measures)) {
      names(algDf)[names(algDf) == ds.props$measures[k]] = paste(key, "(", ds.props$measures[k], ")", sep="")
    }
    
    df = cbind(df, algDf)
  }
  
  df
}
