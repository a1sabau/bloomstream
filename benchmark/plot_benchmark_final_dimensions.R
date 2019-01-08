# dimension stats
stats = data.frame()
stats <- rbind(stats, c(0.0760, 0.5180, 0.0660, 0.2030)) # 5
stats <- rbind(stats, c(0.1120, 1.0580, 0.1330, 0.2180)) # 10
stats <- rbind(stats, c(0.1670, 1.9120, 0.2630, 0.2270)) # 20
stats <- rbind(stats, c(0.2920, 3.5110 , 0.6580, 0.2370)) # 40
stats <- rbind(stats, c(0.5320, 6.8750, 1.4620, 0.2790)) # 80
stats <- rbind(stats, c(1.1020, 13.5410 , 2.3560, 0.3290)) # 160


par(
    oma = c(2, 2, 0, 0), # two rows of text at the outer left and bottom margin
    mar = c(1, 1, 1.1, 0), # space for one row of text at ticks and to separate plots
    mgp = c(2, 1, 0),    # axis label at 2 rows distance, tick labels at 1 row
    xpd = NA # allow content to protrude into outer margin (and beyond)
    )            
matplot(stats, xlab = "Number of dimensions", ylab = "Time (seconds)",
        log="xy",
        #asp=1,
        #at=c(c(5,0), c(10,1), c(20,1.5), c(40,1), c(80,2), c(160,2)),
        at=c(5,10,20,40,80,160),
        axes=F,  x = c(5, 10, 20, 40, 80, 160), 
        #mar=c(0,0,20,0), # bottom, left, top, right
        type = c("b"), pch=c(1,2,3,4), col = 1:4)

axis(side=1, at=c(0, 5,10,20,40,80,160), xpd = FALSE)
axis(side=2, at=c(0, 0.1, 0.3,  1,  4, 14), xpd = FALSE)

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