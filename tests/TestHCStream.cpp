#define BOOST_TEST_DYN_LINK
#include <boost/test/unit_test.hpp>

#include "HCStream.cpp"


/*
 * NOT HANDLED
 * cluster 1 splits into cluster 2,3 in the middle of the window. At window end, all points should have the same label;
 *
 * test number of active/passive clusters
 * test on real datasets
 */

BOOST_AUTO_TEST_CASE( HCStream_ParseEntry ) {
	HCStream* hcStream = new HCStream(10, 0.2, 2, 0.01, 0.01);

	std::vector<std::vector<double>> points = { { 0.1, 0.1 }, { 0.1, 0.3 }, {
			0.1, 0.1 }, { 0.7, 0.7 }, { 0.7, 0.8 }, { 0.7, 0.7 } };
	for (size_t pos = 0; pos < points.size(); pos++) {
		hcStream->parseEntry(pos, points[pos]);
	}

	std::vector<int> actualLabels;
	for (auto &point : points) {
		actualLabels.push_back(hcStream->getLabel(point));
	}

	std::vector<int> trueLabels = { 0, 0, 0, 1, 1, 1 };

	BOOST_CHECK_EQUAL_COLLECTIONS(trueLabels.begin(), trueLabels.end(),
			actualLabels.begin(), actualLabels.end());
}

BOOST_AUTO_TEST_CASE( HCStream_MergeActiveClusters ) {
	int wSize = 8;
	float gridSize = 0.2;
	int densityThld = 2;
	HCStream* hcStream = new HCStream(wSize, gridSize, densityThld, 0.01, 0.01);

	std::vector<std::vector<double>> winPoints;
	std::vector<int> actualLabels;
	std::vector<int> trueLabels;

	// 3 clusters centers: { 0.6, 0.6 }, { 0.2, 0.6 }, { 0.6, 0.8 },
	winPoints = {
			{ 0.6, 0.6 },
			{ 0.2, 0.6 },
			{ 0.6, 0.8 },
			{ 0.6, 0.6 },
			{ 0.2, 0.6 },
			{ 0.6, 0.8 },
			{ 0.6, 0.6 },
			{ 0.6, 0.6 }
	};
	for (size_t pos = 0; pos < winPoints.size(); pos++) {
		hcStream->parseEntry(0 * wSize + pos, winPoints[pos]);
	}

	actualLabels.clear();
	for (auto &point : winPoints) {
		actualLabels.push_back(hcStream->getLabel(point));
	}
	trueLabels.clear();
	trueLabels = { 0, 0, 0, 0, 0, 0, 0, 0 };
	BOOST_CHECK_EQUAL_COLLECTIONS(trueLabels.begin(), trueLabels.end(),	actualLabels.begin(), actualLabels.end());
}

BOOST_AUTO_TEST_CASE( HCStream_SplitPassiveCluster ) {
	int wSize = 8;
	float gridSize = 0.2;
	int densityThld = 2;
	HCStream* hcStream = new HCStream(wSize, gridSize, densityThld, 0.01, 0.01);

	std::vector<std::vector<double>> winPoints;
	std::vector<int> actualLabels;
	std::vector<int> trueLabels;

	std::cout << "split cluster: " << std::endl;
	std::cout << std::endl;
	std::cout << std::endl;

	/*
	1st window: 1 parent cluster { 0.6, 0.6 } is split in two child clusters: { 0.2, 0.6 }, { 0.6, 0.8 }
	{ 0.2, 0.6 } is viewed as evolving from { 0.6, 0.6 }
	there are 3 overlapping clusters: 1 passive, 2 active => one label
	*/
	std::cout << "1st window: " << std::endl;
	winPoints = {
			{ 0.6, 0.6 },
			{ 0.6, 0.6 },
			{ 0.6, 0.6 },
			{ 0.6, 0.6 },
			{ 0.2, 0.6 },
			{ 0.2, 0.6 },
			{ 0.6, 0.8 },
			{ 0.6, 0.8 }
	};
	for (size_t pos = 0; pos < winPoints.size(); pos++) {
		hcStream->parseEntry(0 * wSize + pos, winPoints[pos]);
	}

	actualLabels.clear();
	for (auto &point : winPoints) {
		actualLabels.push_back(hcStream->getLabel(point));
	}
	trueLabels.clear();
	trueLabels = { 0, 0, 0, 0, 0, 0, 0, 0 };
	BOOST_CHECK_EQUAL_COLLECTIONS(trueLabels.begin(), trueLabels.end(),	actualLabels.begin(), actualLabels.end());

	/*
	2nd window: only the child clusters remaing, there are 2 labels
	*/
	std::cout << "2nd window: " << std::endl;
	winPoints = {
			{ 0.2, 0.6 },
			{ 0.2, 0.6 },
			{ 0.6, 0.8 },
			{ 0.6, 0.8 },
			{ 0.2, 0.6 },
			{ 0.2, 0.6 },
			{ 0.6, 0.8 },
			{ 0.6, 0.8 }
	};
	for (size_t pos = 0; pos < winPoints.size(); pos++) {
		hcStream->parseEntry(1 * wSize + pos, winPoints[pos]);
	}

	actualLabels.clear();
	for (auto &point : winPoints) {
		actualLabels.push_back(hcStream->getLabel(point));
	}
	trueLabels = { 0, 0, 1, 1, 0, 0, 1, 1 };
	BOOST_CHECK_EQUAL_COLLECTIONS(trueLabels.begin(), trueLabels.end(),	actualLabels.begin(), actualLabels.end());
}

BOOST_AUTO_TEST_CASE( HCStream_MergePassiveCluster ) {
	int wSize = 8;
	float gridSize = 0.2;
	int densityThld = 2;
	HCStream* hcStream = new HCStream(wSize, gridSize, densityThld, 0.01, 0.01);

	std::vector<std::vector<double>> winPoints;
	std::vector<int> actualLabels;
	std::vector<int> trueLabels;

	std::cout << "split cluster: " << std::endl;
	std::cout << std::endl;
	std::cout << std::endl;

	/*
	1st window: 2 child clusters: { 0.2, 0.6 }, { 0.6, 0.8 } evolve into a single cluster { 0.6, 0.6 },
	there are 3 overlapping clusters: 2 passive, 1 active => one label
	*/
	std::cout << "1st window: " << std::endl;
	winPoints = {
				{ 0.2, 0.6 },
				{ 0.2, 0.6 },
				{ 0.6, 0.8 },
				{ 0.6, 0.8 },
				{ 0.6, 0.6 },
				{ 0.6, 0.6 },
				{ 0.6, 0.6 },
				{ 0.6, 0.6 },
		};
	for (size_t pos = 0; pos < winPoints.size(); pos++) {
		hcStream->parseEntry(0 * wSize + pos, winPoints[pos]);
	}

	actualLabels.clear();
	for (auto &point : winPoints) {
		actualLabels.push_back(hcStream->getLabel(point));
	}
	trueLabels.clear();
	trueLabels = { 0, 0, 0, 0, 0, 0, 0, 0 };
	BOOST_CHECK_EQUAL_COLLECTIONS(trueLabels.begin(), trueLabels.end(),	actualLabels.begin(), actualLabels.end());
}
