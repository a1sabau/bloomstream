#define BOOST_TEST_DYN_LINK
#include <boost/test/unit_test.hpp>

#include <boost/tokenizer.hpp>
#include <sstream>
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <algorithm>
#include <iterator>
#include <cstdlib>
#include <set>

#include "HCStream.cpp"

struct TestContext {
	typedef struct {
		std::vector<std::vector<double>> points;
		std::vector<int> labels;
	} dataset;

	dataset readDataset(std::string filename) {
		dataset ds;

		//std::vector<std::vector<double>> points;

		std::string data(filename);
		std::ifstream in(data.c_str());
		if (!in.is_open())
			return ds;

		std::string line;
		while (std::getline(in, line)) {
			boost::char_separator<char> sep(" ");
			boost::tokenizer<boost::char_separator<char> > tok(line, sep);

			// Tokenizer tok(line);
			std::vector<double> vals;

			std::transform(tok.begin(), tok.end(), std::back_inserter(vals),
					[](const std::string& str)
					{	return std::stold(str);});

			int label = vals.back();
			vals.pop_back();

			ds.points.push_back(vals);
			ds.labels.push_back(label);

		}

		return ds;
	}

	std::string set2Str(std::set<int> vec) {
		std::ostringstream oss;
		std::copy(vec.begin(), vec.end(), std::ostream_iterator<int>(oss, ","));
		return oss.str();
	}
};

BOOST_FIXTURE_TEST_CASE( HCStream_ParseEntry_SmileyDataset, TestContext ) {
	HCStream* hcStream = new HCStream(1000, 0.2, 5, 0.01, 0.01);

	dataset ds = readDataset("./src/datasets/smiley.csv");
	for (size_t pos = 0; pos < ds.points.size(); pos++) {
		hcStream->parseEntry(pos, ds.points[pos]);
	}

	std::set<int> setLabels;
	for (auto &point : ds.points) {
		int label = hcStream->getLabel(point);
		setLabels.insert(label);
	}

	//BOOST_CHECK_EQUAL(4, setLabels.size());

	std::cout << "smiley labels: " << set2Str(setLabels) << std::endl;

	/*
	 sort(actualLabels.begin(), actualLabels.end());
	 auto uniqueLabels = std::unique(actualLabels.begin(), actualLabels.end());
	 int clusterNo = std::distance(uniqueLabels, actualLabels.begin());
	*/
}
