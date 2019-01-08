#ifndef _SBC_SKUTILS_H_
#define _SBC_SKUTILS_H_

#include <sstream>
#include <iostream>
#include "MurmurHash3.h"
#include "commons.h"

class SketchUtils {
public:
	SketchUtils(int m_, int k_);
	std::pair<int, int> optimalCountMinSize(float cmDelta, float cmEpsilon);
	std::vector<int> getHashIdxs(std::vector<int> coords);
	BitSet getBitSignature(std::vector<int> idxs);

	int getHashNo();
	int getBitNo();

private:
	int hashNo;
	int bitNo;
	int bitsPerHash;
	int m, k;
};

#endif
