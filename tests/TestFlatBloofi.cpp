#define BOOST_TEST_DYN_LINK
#include <boost/test/unit_test.hpp>

#include "FlatBloofi.cpp"

BOOST_AUTO_TEST_CASE( FlatBloofiTest_SingleInsert ) {
	int bitNo = 9;
	int wSize = 10;

	std::string bitset;
	std::string actualBitset;
	std::vector<BitSet> bloofiMatrix;
	std::unordered_map<int, BloomContainer> bloomMap;

	FlatBloofi* bloofi = new FlatBloofi(wSize, bitNo);
	bloofiMatrix = bloofi->getMatrix();
	BOOST_CHECK_EQUAL(bitNo, bloofiMatrix.size());

	std::vector<BitSet> bsigns;

	// add 001001001 bitset
	bitset = "001001001";
	bsigns.clear();
	bsigns.push_back(BitSet(std::string(bitset)));
	bloofi->mergeFilters(1, bsigns);
	bloofiMatrix = bloofi->getMatrix();
	BOOST_CHECK_EQUAL(1, bloofiMatrix[0].size());

	bloomMap = bloofi->getBloomMap();
	BOOST_CHECK_EQUAL(1, bloomMap.size());
	BOOST_CHECK_EQUAL(1, bloomMap.count(0));
	boost::to_string(bloomMap[0].filter, actualBitset);
	BOOST_CHECK_EQUAL(bitset, actualBitset);

	// add 100100100 bitset
	bitset = "100100100";
	bsigns.clear();
	bsigns.push_back(BitSet(std::string(bitset)));
	bloofi->mergeFilters(2, bsigns);
	bloofiMatrix = bloofi->getMatrix();
	BOOST_CHECK_EQUAL(2, bloofiMatrix[0].size());

	bloomMap = bloofi->getBloomMap();
	BOOST_CHECK_EQUAL(2, bloomMap.size());
	BOOST_CHECK_EQUAL(1, bloomMap.count(1));
	boost::to_string(bloomMap[1].filter, actualBitset);
	BOOST_CHECK_EQUAL(bitset, actualBitset);
}

BOOST_AUTO_TEST_CASE( FlatBloofiTest_MultipleInserts ) {
	int bitNo = 9;
	int wSize = 10;

	std::string bitset;
	std::string actualBitset;
	std::vector<BitSet> bloofiMatrix;
	std::unordered_map<int, BloomContainer> bloomMap;

	FlatBloofi* bloofi = new FlatBloofi(wSize, bitNo);
	std::vector<BitSet> bsigns;

	// add  001001001, 100100100 bitset
	bitset = "101101101";
	bsigns.clear();
	bsigns.push_back(BitSet(std::string("001001001")));
	bsigns.push_back(BitSet(std::string("100100100")));
	bloofi->mergeFilters(1, bsigns);
	bloofiMatrix = bloofi->getMatrix();
	BOOST_CHECK_EQUAL(1, bloofiMatrix[0].size());

	bloomMap = bloofi->getBloomMap();
	BOOST_CHECK_EQUAL(1, bloomMap.size());
	BOOST_CHECK_EQUAL(1, bloomMap.count(0));
	boost::to_string(bloomMap[0].filter, actualBitset);
	BOOST_CHECK_EQUAL(bitset, actualBitset);
}


BOOST_AUTO_TEST_CASE( FlatBloofiTest_MergeInserts ) {
	int bitNo = 9;
	int wSize = 10;

	std::string bitset;
	std::string actualBitset;
	std::vector<BitSet> bloofiMatrix;
	std::unordered_map<int, BloomContainer> bloomMap;

	FlatBloofi* bloofi = new FlatBloofi(wSize, bitNo);
	std::vector<BitSet> bsigns;

	// add 001001001 bitset
	bsigns.clear();
	bsigns.push_back(BitSet(std::string("001001001")));
	bloofi->mergeFilters(1, bsigns);

	// add 100100100 bitset
	bsigns.clear();
	bsigns.push_back(BitSet(std::string("100100100")));
	bloofi->mergeFilters(2, bsigns);

	// add 001001001, 100100100
	bitset = "101101101";
	bsigns.clear();
	bsigns.push_back(BitSet(std::string("001001001")));
	bsigns.push_back(BitSet(std::string("100100100")));
	bloofi->mergeFilters(3, bsigns);

	bloomMap = bloofi->getBloomMap();
	BOOST_CHECK_EQUAL(1, bloomMap.size());
	BOOST_CHECK_EQUAL(1, bloomMap.count(0));
	boost::to_string(bloomMap[0].filter, actualBitset);
	BOOST_CHECK_EQUAL(bitset, actualBitset);
}


