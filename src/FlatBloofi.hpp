#ifndef SBC_FLATBLOOFI_H
#define SBC_FLATBLOOFI_H

#include <unordered_map>
#include <string>
#include <iostream>
#include <set>

#include "commons.h"
#include "BloomContainer.hpp"

class FlatBloofi
{
public:
  FlatBloofi(int wSize, int bloomLength);

  void mergeFilters(int pos, std::vector<BitSet> newBlooms);
  void addContainer(BloomContainer bloomContainer);
  int getFilterIdx(BitSet &bloom);
  int getLabel(BitSet &bloom);
  void reset(int pos);

  void removeFilter(int idx);
  BitSet getFilter(int idx);
  
  std::vector<BitSet> getMatrix();
  std::unordered_map<int, BloomContainer>  getBloomMap();
  size_t getAvailableIdx();
  int getBloomNo();

  void info();

private:
	BitSet idxLocations;
	std::vector<BitSet> bloofiMatrix;
	std::unordered_map<int, BloomContainer> bloomMap;
	int timeout;

	int bitNo;
	int bloomNo;
	int wSize;
	int lastReset;
};

#endif
