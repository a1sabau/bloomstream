# dimension stats
stats = data.frame()
stats <- rbind(stats, c(0.0760, 0.5180, 0.0660, 0.2030)) # 5
stats <- rbind(stats, c(0.2250, 0.6590, 0.0760, 0.2160)) # 10
stats <- rbind(stats, c(0.8230, 0.7370, 0.0980, 0.225)) # 20
stats <- rbind(stats, c(2.8490, 0.8760, 0.1500, 0.2380)) # 40
stats <- rbind(stats, c(8.0350, 0.9360, 0.2200, 0.2510)) # 80
stats <- rbind(stats, c(8.2500, 0.9550, 0.3670, 0.2900)) # 160


par(
    oma = c(2, 2, 0, 0), # two rows of text at the outer left and bottom margin
    mar = c(1, 1, 2, 0), # space for one row of text at ticks and to separate plots
    mgp = c(2, 1, 0, 0)    # axis label at 2 rows distance, tick labels at 1 row
    #xpd = NA # allow content to protrude into outer margin (and beyond)
    )            
matplot(stats, xlab = "Number of clusters", ylab = "Time (seconds)",
        log="xy",
        #asp=1,
        #at=c(c(5,0.1), c(10,0.2), c(20,1), c(40,2), c(80,5), c(160,10)),
        at=c(5,10,20,40,80,160),
        axes=F,  x = c(5, 10, 20, 40, 80, 160), 
        #mar=c(0,0,20,0), # bottom, left, top, right
        type = c("b"), pch=c(1,2,3,4), col = 1:4)

axis(side=1, at=c(0, 5,10,20,40,80,160), xpd = FALSE)
axis(side=2, at=c(0, 0.1, 0.3, 1, 3, 8), xpd = FALSE)

legend("topleft", 
       bty = "n",
       legend = c("CluStream", "DenStream", "D-Stream", "BloomStream"), 
       col=1:4, pch=c(1,2,3,4)) # optional legend

fbase = "~/Desktop/benchmarks/datasets/synthetic/"
measure="final_benchmark_cluster"



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