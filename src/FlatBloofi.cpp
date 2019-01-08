#include "FlatBloofi.hpp"

FlatBloofi::FlatBloofi(int wSize_, int bitNo_) :
		wSize(wSize_), bitNo(bitNo_) {

	bloomNo = 0;
	bloofiMatrix = std::vector<BitSet>(bitNo, BitSet(0));
	idxLocations = BitSet(0, 0);
	bloomMap = {};
	timeout = wSize;
	lastReset = 0;

	BloomContainer::bitNo = bitNo;
	BloomContainer::clustGen = 0;
}

void FlatBloofi::mergeFilters(int pos, std::vector<BitSet> newBlooms) {
	// check if removal of obsolete filters is required
	if (pos - lastReset > timeout) {
		reset(pos);
		lastReset = pos;
	}

	BloomContainer mergedContainer = BloomContainer();
	std::set<int> activeClusters;
	std::set<int> passiveClusters;
	std::set<int> passiveIdxs;
	std::vector<int> activeTimestamps;

	for (auto &newBloom : newBlooms) {
		mergedContainer.filter |= newBloom;
		//std::cout << "1" << std::endl;

		// populate active, passive links
		int idx = getFilterIdx(newBloom);
		//std::cout << "idx: " << idx << std::endl;
		if (idx != -1) {
			BloomContainer matchedContainer = bloomMap[idx];
			int elapsed = pos - matchedContainer.timestamp;

			//std::cout << "pos: " << pos << " " << matchedContainer.timestamp << std::endl;
			// active filter
			if (elapsed < timeout / 2) {
				//std::cout << "macthed active cluster" << std::endl;
				activeClusters.insert(matchedContainer.clust);
				activeTimestamps.push_back(matchedContainer.timestamp);
				mergedContainer.filter |= matchedContainer.filter;
				removeFilter(idx);
			}
			// pasive filter
			else if (elapsed < timeout) {
				if (matchedContainer.enableChild) {
					passiveClusters.insert(matchedContainer.clust);
					passiveIdxs.insert(idx);
				}
			}
			// obsolete filter
			else {
				//std::cout << "obsolete idx: " << idx << std::endl;
				removeFilter(idx);
			}
		}
	}
	//std::cout << "3" << std::endl;

	// determine new active merged cluster idx based on computed links in the following order: common, passive, active
	int activeClust = -1;
	std::set<int> commonLinks;
	std::set_intersection(activeClusters.begin(), activeClusters.end(), passiveClusters.begin(), passiveClusters.end(),
	                  std::inserter(commonLinks, commonLinks.begin()));
	if (!commonLinks.empty()) {
		activeClust = *commonLinks.begin();
	}
	else if (!passiveClusters.empty()) {
		activeClust = *passiveClusters.begin();
	}
	else if (!activeClusters.empty()) {
		activeClust = *activeClusters.begin();
	}
	else {
		//std::cout << "new clust" << std::endl;
		activeClust = BloomContainer::clustGen++;
	}
	mergedContainer.clust = activeClust;

	//std::cout << "4" << std::endl;
	// determine new active merged cluster timestamp
	int activeTimestamp = activeTimestamps.empty() ? pos :  *std::min(activeTimestamps.begin(), activeTimestamps.end());
	mergedContainer.timestamp = activeTimestamp;

	//std::cout << "5" << std::endl;
	// all matched passive filters can't no longer have children, should share the same cluster id
	for (auto &idx : passiveIdxs) {
		bloomMap[idx].enableChild = false;
		bloomMap[idx].clust = activeClust;
	}

	//std::cout << "6" << std::endl;
	// add the new merged filter
	addContainer(mergedContainer);
}

void FlatBloofi::addContainer(BloomContainer bloomContainer) {
	//std::cout << "add container, clust: " << bloomContainer.clust << std::endl;
	// get next available idx
	size_t idx = getAvailableIdx();

	// register bloom
	bloomMap[idx] = bloomContainer;

	// expand bloofy matrix if needed
	if (idx == bloofiMatrix[0].size()) {
		for (int i = 0; i < bitNo; i++) {
			bloofiMatrix[i].push_back(false);
		}
	}

	// update bloofy matrix
	for (int i = 0; i < bitNo; i++) {
		if (bloomContainer.filter[i] == false)
			continue;
		bloofiMatrix[i][idx] = true;
	}

	// update bloom filters total
	bloomNo += 1;
}

int FlatBloofi::getFilterIdx(BitSet &bloom) {
	BitSet boolResult = BitSet(bloofiMatrix[0].size());
	boolResult.flip();

	for (int i = 0; i < bitNo; i++) {
		if (bloom[i] == false)
			continue;

		boolResult &= bloofiMatrix[i];

		// if no index is set stop: no results found
		if (boolResult.none()) {
			return -1;
		}
	}

	for (size_t i = 0; i < boolResult.size(); i++) {
		if (boolResult[i] == true) {
			return i;
		}
	}

	return -1;
}

int FlatBloofi::getLabel(BitSet &bloom) {
	int idx = getFilterIdx(bloom);
	if (idx != -1) {
		//std::cout << "label, filter idx: " << idx << " clust: " << bloomMap[idx].clust << std::endl;
		return bloomMap[idx].clust;
	}

	return -1;
}


void FlatBloofi::reset(int pos) {
	for (size_t idx = 0; idx < idxLocations.size(); idx++) {
		if (idxLocations[idx] == true and pos - bloomMap[idx].timestamp > timeout) {
			removeFilter(idx);
		}
	}
}

void FlatBloofi::removeFilter(int idx) {
	//std::cout << "removeFilter: " << idx << std::endl;

	// update bloofy matix
	for (int i = 0; i < bitNo; i++) {
		bloofiMatrix[i][idx] = false;
	}

	// update available idxs
	idxLocations[idx] = false;

	// update map
	bloomMap.erase(idx);

	// update bloom filters total
	bloomNo -= 1;
}

// can have old blooms still not deleted if nothing matched them
size_t FlatBloofi::getAvailableIdx() {
	// re-use existing idx if empty
	for (size_t i = 0; i < idxLocations.size(); i++) {
		if (idxLocations[i] == false) {
			idxLocations[i] = true;
			return i;
		}
	}

	// assign new idx
	idxLocations.push_back(true);
	return idxLocations.size() - 1;
}

/*
FlatBloofi::BitSet FlatBloofi::getFilter(int idx) {
	return bloomMap[idx];
}
*/

void FlatBloofi::info() {
	//Rcpp::Rcout << "bloomNo: " << bloomNo << std::endl;
}

int FlatBloofi::getBloomNo() {
	return bloomNo;
}

std::vector<BitSet> FlatBloofi::getMatrix() {
	return bloofiMatrix;
}

std::unordered_map<int, BloomContainer> FlatBloofi::getBloomMap() {
	return bloomMap;
}

