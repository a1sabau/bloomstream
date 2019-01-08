# dimension stats
stats = data.frame()
stats <- rbind(stats, c(0.0760, 0.5180, 0.0660, 0.2030)) # 2
stats <- rbind(stats, c(0.1480, 2.1420, 0.2670, 0.357)) # 4
stats <- rbind(stats, c(0.2820, 10.1680, 1.000, 0.697)) # 8
stats <- rbind(stats, c(0.5850, NA , 1.6210, 1.3970)) # 16
stats <- rbind(stats, c(1.1890, NA, 2.5310, 2.7760)) # 32
stats <- rbind(stats, c(2.4150, NA, 4.4580, 5.5470)) # 64
stats <- rbind(stats, c(5.0370, NA, 9.2750, 11.1380)) # 128

#stats <- stats/2
print(stats)

par(
    oma = c(2, 2, 0, 0), # two rows of text at the outer left and bottom margin
    mar = c(1, 1, 0, 0), # space for one row of text at ticks and to separate plots
    mgp = c(2, 1, 0),    # axis label at 2 rows distance, tick labels at 1 row
    #par(pty=""),
    #asp=1,
    xpd = NA # allow content to protrude into outer margin (and beyond)
    )            
matplot(stats, xlab = "Window size (unit:K)", ylab = "Time (seconds)",
        log="xy",
        #ylim=range(c(0,1)),
        #asp=1,
        #at=c(c(2,0.1), c(4,1), c(8,2), c(16,4), c(80,8), c(160,0.3)),
        #at=c(2,4,8,16,32,64),
        axes=F,  
        x = c(2,4,8,16,32,64,128), 
        #mar=c(0,0,20,0), # bottom, left, top, right
        type = c("b"), pch=c(1,2,3,4), col = 1:4)

axis(side=1, at=c(0,2,4,8,16,32,64, 128), xpd = FALSE)
axis(side=2, at=c(0, 0.1, 0.3, 1,   4,   11), xpd = FALSE)

legend("topleft", 
       bty = "n",
       legend = c("CluStream", "DenStream", "D-Stream", "BloomStream"), 
       col=1:4, pch=c(1,2,3,4)) # optional legend

fbase = "~/Desktop/benchmarks/datasets/synthetic/"
measure="final_benchmark_winsize"



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
#savePlotEPS(measure)