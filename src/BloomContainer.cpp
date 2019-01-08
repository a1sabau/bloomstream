#include "BloomContainer.hpp"

int BloomContainer::clustGen = 0;
int BloomContainer::bitNo;

BloomContainer::BloomContainer()  {
	filter = BitSet(bitNo, 0);
	clust = -1;
	enableChild = true;
	timestamp = -1;

}

