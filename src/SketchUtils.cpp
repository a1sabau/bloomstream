#include "SketchUtils.hpp"

SketchUtils::SketchUtils(int m_, int k_) :
		m(m_), k(k_) {
	//std::pair<uint, uint> countMinSize = optimalCountMinSize(cmDelta, cmEpsilon);
	//hashNo = countMinSize.first;
	//bitNo = countMinSize.second;
	hashNo = k;
  bitNo = m;

	bitsPerHash = bitNo / hashNo;
  
  std::cout << "bloom, m = " << bitNo << " , k = " << hashNo << std::endl;
}

std::pair<int, int> SketchUtils::optimalCountMinSize(float cmDelta, float cmEpsilon) {
	int w = std::ceil(exp(1) / cmEpsilon);
	int d = std::ceil(log(1 / cmDelta));

	int hashNo = d;
	int bitNo = w * d;

	std::pair<int, int> sketchSize;
	sketchSize.first = hashNo;
	sketchSize.second = bitNo;

	return sketchSize;
}

std::vector<int> SketchUtils::getHashIdxs(std::vector<int> coords) {
	std::stringstream keyStream;
	std::copy(coords.begin(), coords.end(), std::ostream_iterator<int>(keyStream, " "));

	std::string key = keyStream.str();
	//std::cout << "key: " << key << std::endl;

	uint32_t h1, h2;
	MurmurHash3_x86_32(key.c_str(), key.length(), 0, &h1);
	MurmurHash3_x86_32(key.c_str(), key.length(), 1, &h2);

	int offset = 0;
	std::vector<int> idxs(hashNo);
	for (int i = 0; i < hashNo; i++) {
		idxs[i] = offset + (h1 + i * h2) % bitsPerHash;
		offset += bitsPerHash;
	}

	return idxs;
}

BitSet SketchUtils::getBitSignature(std::vector<int> idxs) {
	BitSet bsign = BitSet(bitNo, 0);
	for (auto &idx : idxs) {
		bsign[idx] = 1;
	}
	return bsign;
}

int SketchUtils::getHashNo() {
	return hashNo;
}

int SketchUtils::getBitNo() {
	return bitNo;
}

