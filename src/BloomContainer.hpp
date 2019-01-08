#ifndef _SBC_BLOOMCONTAINER_H_
#define _SBC_BLOOMCONTAINER_H_

#include "commons.h"

class BloomContainer {
public:
	static int bitNo;
	static int clustGen;

	int timestamp;
	int clust;
	BitSet filter;
	bool enableChild;

	BloomContainer();

private:


};

#endif
