#include <Rcpp.h>
#include <utility>

#include <vector>
#include <string>
#include <algorithm>
#include <sstream>
#include <iterator>
#include <iostream>
#include <math.h>

#include "commons.h"
#include "Grid.hpp"
#include "SketchUtils.hpp"
#include "CountMinSketch.hpp"
#include "FlatBloofi.hpp"


class HCStream {
public:

	HCStream(int wSize, float gridSize, int densityThreshold, int m, int k) {

		grid = new Grid(gridSize);

		utils = new SketchUtils(m, k);

		countMin = new CountMinSketch(wSize, utils->getBitNo(), densityThreshold);

		bloofi = new FlatBloofi(wSize, utils->getBitNo());
	}

	
	 void cluster(int startPos, Rcpp::NumericMatrix& data) {
  	 int entryNo = data.nrow();
  	 for (int i = 0; i < entryNo; i++) {
    	 Rcpp::NumericVector p = data(i, Rcpp::_);
    	 std::vector<double> point = Rcpp::as<std::vector<double>>(p);
    
    	 parseEntry(startPos + i, point);
  	 }
  
  	 bloofi->info();
	 }

	 std::vector<int> getLabels(Rcpp::NumericMatrix& data) {
  	 int entryNo = data.nrow();
  	 std::vector<int> labels;
  	 for (int i = 0; i < entryNo; i++) {
    	 Rcpp::NumericVector p = data(i, Rcpp::_);
    	 std::vector<double> point = Rcpp::as<std::vector<double>>(p);
    
    	 labels.push_back(getLabel(point));
  	 }

	 return labels;
	 }
	 

	int getMacroClusterNo() {
		return bloofi->getBloomNo();
	}

	void parseEntry(int pos, std::vector<double> point) {
		//std::cout << "point: " << vec2StrD(point) << std::endl;
		std::vector<int> coords = grid->getGridCoords(point);
		//std::cout << "coords: " << vec2Str(coords) << std::endl;
		std::vector<int> idxs = utils->getHashIdxs(coords);

		//std::cout << "idxs: " << vec2Str(idxs) << std::endl;
		bool expandCell = countMin->update(pos, idxs);

		// we're only interested in core points
		if (!expandCell)
			return;

		// get bit signatures for all nearyby grid cells
		std::vector<BitSet> bsigns;
		for (auto &nearCoord : grid->getNearCoords(coords)) {
			std::vector<int> nearIdx = utils->getHashIdxs(nearCoord);
			bsigns.push_back(utils->getBitSignature(nearIdx));
		}

		bloofi->mergeFilters(pos, bsigns);
	}

	int getLabel(std::vector<double> point) {
		std::vector<int> coords = grid->getGridCoords(point);
		std::vector<int> idxs = utils->getHashIdxs(coords);
		BitSet bsign = utils->getBitSignature(idxs);

		return bloofi->getLabel(bsign);
	}

	std::string vec2Str(std::vector<int> vec) {
		std::ostringstream oss;
		std::copy(vec.begin(), vec.end(), std::ostream_iterator<int>(oss, ","));
		return oss.str();
	}

	std::string vec2StrD(std::vector<double> vec) {
		std::ostringstream oss;
		std::copy(vec.begin(), vec.end(), std::ostream_iterator<double>(oss, ","));
		return oss.str();
	}

private:
	Grid* grid;
	SketchUtils* utils;
	CountMinSketch* countMin;
	FlatBloofi* bloofi;
};


 using namespace Rcpp;


 RCPP_EXPOSED_CLASS(HCStream)
 RCPP_MODULE(mod_hcstream) {

 class_<HCStream>("HCStream")

 .constructor<int, float, int, int, int>("sets initial value")
 .method("cluster", &HCStream::cluster, "Cluster dataframe")
 .method("getLabels", &HCStream::getLabels, "Get labels")
 .method("getMacroClusterNo", &HCStream::getMacroClusterNo, "Get getMacroClusterNo")
 ;
 }
 

