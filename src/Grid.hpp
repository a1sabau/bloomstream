#ifndef _SBC_GRID_H_
#define _SBC_GRID_H_

#include <vector>
#include <cmath>
#include <algorithm>
#include <iostream>

class Grid {
public:
	Grid(float gridSize);
	std::vector<int> getGridCoords(std::vector<double> point);
	std::vector<std::vector<int>> getNearCoords(std::vector<int> coords);

private:
	float gridSize;
};

#endif
