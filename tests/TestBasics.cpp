#define BOOST_TEST_DYN_LINK
#include <boost/test/unit_test.hpp>

#include "Grid.hpp"
#include "SketchUtils.hpp"
#include "CountMinSketch.hpp"

BOOST_AUTO_TEST_CASE( GridTest_PositiveDimRanges ) {
	float gridSize = 0.2;

	Grid* grid = new Grid(gridSize);

	std::vector<double> point = { 0.1, 0.1 };
	std::vector<int> coordsValues = grid->getGridCoords(point);

	std::vector<int> coordsExpected = { 0, 0 };


	BOOST_CHECK_EQUAL_COLLECTIONS(coordsValues.begin(), coordsValues.end(),
			coordsExpected.begin(), coordsExpected.end());


	std::vector<std::vector<int>> nearCoordsValues = grid->getNearCoords(
			coordsExpected);
	BOOST_CHECK_EQUAL(5, nearCoordsValues.size());
}



BOOST_AUTO_TEST_CASE( GridTest_MixedDimRanges ) {
	float gridSize = 0.2;

	Grid* grid = new Grid(gridSize);

	std::vector<double> point = { -0.5, -0.5 };
	std::vector<int> coordsValues = grid->getGridCoords(point);
	std::vector<int> coordsExpected = { -2, -2 };

	BOOST_CHECK_EQUAL_COLLECTIONS(coordsValues.begin(), coordsValues.end(),
			coordsExpected.begin(), coordsExpected.end());

	std::vector<std::vector<int>> nearCoordsValues = grid->getNearCoords(
			coordsExpected);
	BOOST_CHECK_EQUAL(5, nearCoordsValues.size());


	point =	{	0.9, 0.9};
	coordsValues = grid->getGridCoords(point);
	coordsExpected = {	4, 4};

	BOOST_CHECK_EQUAL_COLLECTIONS(coordsValues.begin(), coordsValues.end(),
			coordsExpected.begin(), coordsExpected.end());

}


BOOST_AUTO_TEST_CASE( SketchUtilsTest ) {
	float cmDelta = 0.01;
	float cmEpsilon = 0.05;
	SketchUtils* utils = new SketchUtils(cmDelta, cmEpsilon);

	BOOST_CHECK_EQUAL(utils->getBitNo(), 275);
	BOOST_CHECK_EQUAL(utils->getHashNo(), 5);
}

BOOST_AUTO_TEST_CASE( CountMinSketchTest_SingleWindow ) {
	int thld = 2;
	int bitNo = 20;
	int wSize = 10;
	int hashNo = 10;

	CountMinSketch* countMin = new CountMinSketch(wSize, bitNo, thld);

	BOOST_CHECK_EQUAL(false, countMin->update(0, std::vector<int> { 0, hashNo + 0 }));
	BOOST_CHECK_EQUAL(true, countMin->update(1, std::vector<int> { 0, hashNo + 0 }));
	BOOST_CHECK_EQUAL(false, countMin->update(2, std::vector<int> { 0, hashNo + 0 }));

	BOOST_CHECK_EQUAL(false, countMin->update(3, std::vector<int> { 1, hashNo + 0 }));
	BOOST_CHECK_EQUAL(true, countMin->update(4, std::vector<int> { 1, hashNo + 0 }));
	BOOST_CHECK_EQUAL(false, countMin->update(5, std::vector<int> { 1, hashNo + 0 }));
}

BOOST_AUTO_TEST_CASE( CountMinSketchTest_MultipleWindows ) {
	int thld = 2;
	int bitNo = 20;
	int wSize = 4;
	int hashNo = 10;

	CountMinSketch* countMin = new CountMinSketch(wSize, bitNo, thld);

	// win 1
	//std::cout << "win1" << std::endl;
	BOOST_CHECK_EQUAL(false, countMin->update(0, std::vector<int> { 0, hashNo + 0 }));
	BOOST_CHECK_EQUAL(true, countMin->update(1, std::vector<int> { 0, hashNo + 0 }));
	BOOST_CHECK_EQUAL(false, countMin->update(2, std::vector<int> { 0, hashNo + 0 }));
	BOOST_CHECK_EQUAL(false, countMin->update(3, std::vector<int> { 0, hashNo + 0 }));

	// win 2
	//std::cout << "win2" << std::endl;
	BOOST_CHECK_EQUAL(true, countMin->update(4, std::vector<int> { 0, hashNo + 0 }));
	BOOST_CHECK_EQUAL(false, countMin->update(5, std::vector<int> { 0, hashNo + 1 }));
	BOOST_CHECK_EQUAL(false, countMin->update(6, std::vector<int> { 1, hashNo + 3 }));
	BOOST_CHECK_EQUAL(false, countMin->update(7, std::vector<int> { 1, hashNo + 2 }));

	// win 3
	//std::cout << "win3" << std::endl;
	BOOST_CHECK_EQUAL(false, countMin->update(8, std::vector<int> { 0, hashNo + 0 }));
	BOOST_CHECK_EQUAL(false, countMin->update(9, std::vector<int> { 1, hashNo + 3 }));
	BOOST_CHECK_EQUAL(false, countMin->update(10, std::vector<int> { 0, hashNo + 1 }));
	BOOST_CHECK_EQUAL(false, countMin->update(11, std::vector<int> { 0, hashNo + 0 }));

	// win 4
	//std::cout << "win4" << std::endl;
	BOOST_CHECK_EQUAL(true, countMin->update(12, std::vector<int> { 0, hashNo + 0 }));
	BOOST_CHECK_EQUAL(false, countMin->update(13, std::vector<int> { 1, hashNo + 0 }));
	BOOST_CHECK_EQUAL(false, countMin->update(14, std::vector<int> { 0, hashNo + 0 }));
	BOOST_CHECK_EQUAL(false, countMin->update(15, std::vector<int> { 0, hashNo + 0 }));
}
