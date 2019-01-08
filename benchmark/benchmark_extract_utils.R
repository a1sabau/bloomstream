getTopWindows = function() {
  topIdxs = list()
  topInfo = list()
  minVal = 0
  
  dsPath = paste(ds.props$fbase, ds.props$dsFile, sep="")
  cols = c(ds.props$dataCols[1], ds.props$labelCol)
  stream <- DSD_ReadCSV(gzfile(dsPath), take = cols)
  
  idx = 0
  while (idx + ds.props$wSize < ds.props$entryNo) {
    wdata = get_points(stream, n = ds.props$wSize)
    labels = unlist(wdata[,ncol(wdata)], use.names = FALSE)
    len = length(unique(labels))
   
    if (idx %% (100 * ds.props$wSize) == 0) {
      print(paste("idx:", idx, len))
    }
    
    validIdx = idx > ds.props$wPadding * ds.props$wSize
    if (validIdx && len > minVal && len > ds.props$minLabelNo) {
      # add new key for topIdx
      topIdxs[toString(idx)] = len
      
      # add new key for topInfo
      agg = aggregate(labels, by=list(unlist(labels)), FUN=length)
      info = paste(agg[,c(1)], agg[,c(2)], sep="-")
      topInfo[toString(idx)] = toString(info)
      
      # replace top val 
      if (length(topIdxs) > ds.props$topNo) {
        # sort values
        sortedName = names(sort(unlist(topIdxs)))
        sortedKeys = strsplit(sortedName, split = " ")
        
        # remove min value, extract new minVal
        delKey = sortedKeys[[1]]
        minKey = sortedKeys[[2]]
        minVal = topIdxs[[minKey]]
        topIdxs[[delKey]] = NULL
        topInfo[[delKey]] = NULL
      }
    }
    
    idx = idx + ds.props$wSize
  }
  
  list(topIdxs, topInfo)
}

saveTopWindows = function() {
  topData = getTopWindows()
  print(topData)
  topIdxs = topData[[1]]
  topInfo = as.vector(unlist(topData[[2]]))

  df = data.frame(stack(topIdxs))
  colnames(df)[1] <- "classNo"
  colnames(df)[2] <- "winNo"
  
  df$labels <- topInfo
  
  topWindowFile = paste(ds.props$fbase, "top_wsize_", ds.props$wSize, "_topNo_", ds.props$topNo, ".csv", sep="")
  write.table(df, file = topWindowFile, append = FALSE, sep = ",", col.names = TRUE, row.names = FALSE)
}

loadTopWindows = function() {
  topWindowFile = paste(ds.props$fbase, "top_wsize_", ds.props$wSize, "_topNo_", ds.props$topNo, ".csv", sep="")
  df = read.csv(file = topWindowFile)
  df
}

genTopRows = function() {
  dsPath = paste(ds.props$fbase, ds.props$dsFile, sep="")
  
  topIdx = 1
  while (topIdx <= ds.props$topNo) {
    # get data
    minIdx = ds.props$top.windows[topIdx, 2] - ds.props$wPadding * ds.props$wSize
    maxIdx = ds.props$top.windows[topIdx, 2] + (ds.props$wPadding + 1) * ds.props$wSize
    skipVal = minIdx * ds.props$wSize
    print(paste("skipVal:", skipVal))
    stream <- DSD_ReadCSV(gzfile(dsPath), skip = minIdx - 1)
    print("reading")
    wdata = get_points(stream, n=(maxIdx - minIdx))
    
    # save data
    dfFile = paste(ds.props$fbase, "df_wsize_", ds.props$wSize, "_topNo_", ds.props$topNo, "_idx_", topIdx, ".csv", sep="")
    write.table(wdata, file = dfFile, append = FALSE, sep = ",", col.names = FALSE, row.names = FALSE)
    
    # next top idx
    topIdx = topIdx + 1
  }
}
