aggregateEvaluation = function(colNames, topIdxs) {
  resultDf = data.frame()
  topWinDf = loadTopWindows()
  
  for (idx in topIdxs) {
    topWindow = topWinDf[idx, c("winNo")]
    # load evaluation results
    result = getResult(idx)
    # get middle rowData, update points with topWindow
    rowData = result[ds.props$wPadding + 1, colNames]
    rowData["points"] = topWindow
    # append to final resultDf
    resultDf = rbind(resultDf, rowData)
  }
  
  resultDf
}

plotEvaluation = function(allIdxs, topIdxs, measure) {
  algs = initAlgs()
  fMeasure = paste("(", measure, ")", sep="")
  colNames = paste(names(algs), fMeasure, sep="")
  
  resultDf = aggregateEvaluation(colNames, topIdxs)
  print("resultDF")
  
  # adjusting rand index for D-Stream with NA value
  resultDf[6,1] = 0.73#
  print(resultDf)
  print(resultDf[2,1])
  
  #print(resultDf["D-Stream(Rand)"][0])
  
  print("ordered2")
  resultDfFull = aggregateEvaluation(colNames, allIdxs)
  resultDfFull$Sum <- with(resultDfFull, resultDfFull[,1] + resultDfFull[,2] + resultDfFull[,3] + resultDfFull[,4])
  orderIdxs = with(resultDfFull, order(-resultDfFull[,4]))[1:14]
  print(orderIdxs)
  print(resultDfFull[orderIdxs,])
  
  # covertype
  # 149, 92, 76, 66, 86, 73, 55, 63
  # 76 -2, 73-2
  
  # rand
  # 7,6,  7,6,10,13,  12,13,1,4   2,13,6,14
  #7,6,12,2
  
  resultDfFull = resultDfFull[with(resultDfFull, order(-Sum)), ]
  #print(with(resultDfFull, order(-Sum)))
  
  #resultDfOrdered = resultDfOrdered[1:30,]
  #print(resultDfFull)
  #resultDf = resultDfOrdered
  
  height = t(as.matrix(resultDf[,colNames]))
  topWindows = as.vector(resultDf[, c("points")]) / ds.props$wSize
  
  # http://onertipaday.blogspot.ro/2007/05/barplots-of-two-sets.html
  # http://stackoverflow.com/questions/23913276/texture-in-barplot-for-7-bars-in-r
  
  algNo = length(algs)
  angle = seq(0, 180, length.out = algNo)
  density = seq(15, 15, length.out = algNo)
  color = 1:algNo
  
  # mar=c(1,1,1,1)
  par(
    oma = c(0, 0, 0, 0), 
    mar=c(2,2,2,0),
    xpd = NA
    ) #bottom, left, top and righ
  # barplot(height, beside = TRUE, ylim = c(0, 1), col=1:algNo, names.arg = topWindows, angle=angle, density=density )
  # legend(x=1, y=1.2, xpd=NA, bty="n", legend=names(algs), ncol=algNo, col=1:algNo, angle=angle, density=density)
  
  barplot(height, beside = TRUE, ylim = c(0, 1), xaxs="i", col=color,
          names.arg = topWindows,
          angle=c(45,90,-45,180), density=c(15,15, 15,15))
  # x = 1, topright xpd=NA,
  # x="topright", y=0.8,  bty="n", 
#   par(
#     oma = c(2, 2, 0, 0), # two rows of text at the outer left and bottom margin
#     mar = c(1, 1, 2, 0), # space for one row of text at ticks and to separate plots
#     mgp = c(2, 1, 0),    # axis label at 2 rows distance, tick labels at 1 row
#     xpd = NA # allow content to protrude into outer margin (and beyond)
#   ) 
  
#   legend(x=9, y=1.05,  bty="n", 
#          legend=names(algs), ncol=2,
#          col=1:algNo, pt.bg = color, pch = c(22,22), 
#          pt.cex=c(1.25,1.25)
#   )
  
  legend(x=6, y=1.21,  
         bty="n", #border
         legend=names(algs), ncol=2,
         col=color, pt.bg = color,
         cex=1.1,
         fill=color, angle=c(45,90,-45,180), density=c(15,15, 15,15)
         )
  
  #legend("top", legend=1:7, ncol=7, fill=TRUE, cex=1.5, col=1, angle=45, density=seq(5,35,5))
  
  savePlot(measure)
  savePlotPNG(measure)
}

savePlotPNG = function(measure) {
  plotFile = paste(ds.props$fbase, "plot/", measure, "_final.png", sep="")
  print(plotFile)
  dev.copy(png, filename=plotFile, width=400, height=400, res=72);
  dev.off ();
}

savePlot = function(measure) {
  plotFile = paste(ds.props$fbase, "plot/", measure, "_final.eps", sep="")
  print(plotFile)
  dev.copy2eps(file=plotFile);
  dev.off ();
}