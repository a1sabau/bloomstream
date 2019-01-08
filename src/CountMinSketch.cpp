#include "CountMinSketch.hpp"

CountMinSketch::CountMinSketch(int wSize_, int bitNo_, int densityThreshold_) :
		bitNo(bitNo_), densityThreshold(densityThreshold_), wSize(wSize_) {

	m = std::vector<int>(bitNo, 0);
	expandFilter = BitSet(bitNo, 0);
	timestamp = std::vector<int>(bitNo, 0);
	timeout = floor(wSize / densityThreshold);
}

bool CountMinSketch::update(int pos, std::vector<int> idxs) {
	if (pos % wSize == 0)
		reset();

	int count = std::numeric_limits<int>::max();

	bool alreadyExpanded = 1;
	for (auto &idx : idxs) {
		// if cell is expired reset its counter
		if (pos - timestamp[idx] > timeout) {
			m[idx] = 1;
		} else {
			m[idx] += 1;
		}

		// update timestamp, density, expanded flag
		timestamp[idx] = pos;
		count = std::min(count, m[idx]);
		alreadyExpanded &= expandFilter[idx];
	}

	//std::cout << pos << " " << alreadyExpanded << " " << count << " " << std::endl;
	if (!alreadyExpanded and count >= densityThreshold) {
		for (auto &idx : idxs) {
			expandFilter[idx] = 1;
		}
		return true;
	} else {
		return false;
	}
}

void CountMinSketch::reset() {
	//std::cout << "reset" << std::endl;
	// scale down mincount values exceeding threshold to threshold
	for (size_t i = 0; i < m.size(); i++) {
		if (m[i] > densityThreshold) {
			m[i] = densityThreshold;
		}
	}

	// reset expandCell bloom filter
	expandFilter.reset();
}

