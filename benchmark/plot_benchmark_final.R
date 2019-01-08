# dimension stats
stats = data.frame()
stats <- rbind(stats, c(0.0620000, 0.0800000, 0.083, 0.189)) # 5
stats <- rbind(stats, c(0.1060000, 0.1110000, 0.1620000, 0.192)) # 10
stats <- rbind(stats, c(0.1760000, 0.1640000, 0.3030000, 0.1970000)) # 20
stats <- rbind(stats, c(0.2750000, 0.2830000 , 0.4890000, 0.2150000)) # 40
stats <- rbind(stats, c(0.5320000, 0.5060000, 1.1580000, 0.2500000)) # 80
stats <- rbind(stats, c(1.0120000, 0.9840000 , 2.1870000, 0.3450000)) # 160


par(
    oma = c(2, 2, 0, 0), # two rows of text at the outer left and bottom margin
    mar = c(1, 1, 0, 0), # space for one row of text at ticks and to separate plots
    mgp = c(2, 1, 0),    # axis label at 2 rows distance, tick labels at 1 row
    xpd = NA # allow content to protrude into outer margin (and beyond)
    )            
matplot(stats, xlab = "Number of dimensions", ylab = "Time (seconds)",
        log="x",
        #asp=1,
        #at=c(c(5,0), c(10,1), c(20,1.5), c(40,1), c(80,2), c(160,2)),
        at=c(5,10,20,40,80,160),
        axes=T,  x = c(5, 10, 20, 40, 80, 160), 
        #mar=c(0,0,20,0), # bottom, left, top, right
        type = c("b"), pch=c(1,2,3,4), col = 1:4)

axis(side=2)
legend("topleft", 
       bty = "n",
       legend = c("CluStream", "DenStream", "D-Stream", "BloomStream"), 
       col=1:4, pch=c(1,2,3,4)) # optional legend

fbase = "~/Desktop/benchmarks/datasets/synthetic/"
measure="final_benchmark_dimension"



savePlotPNG = function(measure) {
  plotFile = paste(fbase, measure, ".png", sep="")
  print(plotFile)
  dev.copy(png, filename=plotFile, res=72);
  dev.off ();
}

savePlotEPS = function(measure) {
  plotFile = paste(fbase, measure, ".eps", sep="")
  print(plotFile)
  dev.copy2eps(file=plotFile);
  dev.off ();
}

savePlotPNG(measure)
savePlotEPS(measure)