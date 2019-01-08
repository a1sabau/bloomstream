#ifndef _SBC_COUNTMIN_H_
#define _SBC_COUNTMIN_H_

#include <limits>
#include <vector>
#include <cmath>
#include <iostream>

#include "commons.h"
#include "FlatBloofi.hpp"

class CountMinSketch {
public:
	CountMinSketch(int wSize_, int bitNo_, int densityThreshold_);
	bool update(int pos, std::vector<int> idxs);
	void reset();

private:
	int bitNo, densityThreshold;
	int wSize, timeout;
	std::vector<int> m;
	std::vector<int> timestamp;
	BitSet expandFilter;
};

#endif
