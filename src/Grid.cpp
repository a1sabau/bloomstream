#include "Grid.hpp"

Grid::Grid(float gridSize_) :
		gridSize(gridSize_) {
}

// http://answers.unity3d.com/questions/52936/round-a-vector3-to-a-grid-position.html
std::vector<int> Grid::getGridCoords(std::vector<double> point) {
	size_t dimNo = point.size();
	std::vector<int> coords(dimNo);
	for (size_t dimIdx = 0; dimIdx < dimNo; dimIdx++) {
		coords[dimIdx] = std::floor(point[dimIdx] / gridSize + 0.5);
    //std::cout << point[dimIdx] << " " << gridSize << " " << std::floor(point[dimIdx] / gridSize + 0.5) << std::endl;
	}
	// print(coords)
	return coords;
}

std::vector<std::vector<int>> Grid::getNearCoords(std::vector<int> coords) {
	std::vector<int> incrVals { -1, 1 };
	std::vector<std::vector<int>> nearCoords;

	for (size_t dimIdx = 0; dimIdx < coords.size(); dimIdx++) {
		for (int &incrVal : std::vector<int> { -1, 1 }) {
			int nearVal = coords[dimIdx] + incrVal;
			// std::cout << "nearVal: " << nearVal << std::endl;
			std::vector<int> nearCoord = coords;
			nearCoord[dimIdx] = nearVal;
			nearCoords.push_back(nearCoord);
		}
	}
	nearCoords.push_back(coords);
	return nearCoords;
}
