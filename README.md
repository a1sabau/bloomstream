# bloomstream

BloomStream [1] is implemented in C++ with an R interface for the Stream R package [2]. 
Throughout the code BloomStream is referred as HCStream, the original name used prior to publishing the arxiv version.
The folder structure follows RStudio project conventions.

Rcpp is used to expose the main algorithm class `HCStream` as the `mod_hcstream` rcpp module.
Running the various benchmarks available under the corresponding folder assumes HCStream has been compiled and it's available for loading via 
```
library(hcstream)
````

References:

[1] - Sabau, Andrei Sorin. ["Stream Clustering using Probabilistic Data Structures."]() arXiv preprint arXiv:1612.02701 (2016).

[2] - Hahsler, M., M. Bolanos, and J. Forrest. ["stream: Infrastructure for Data Stream Mining. R package version 1.2."](https://CRAN.R-project.org/package=stream)
