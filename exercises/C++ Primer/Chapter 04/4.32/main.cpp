// Ex 4.32: initializing vector from array

#include "../Ch4headers.h"

int main()
{
	const int intArraySize = 10;
	int arrayOfInts[intArraySize] = {0, 1, 1, 2, 3, 5, 8, 13, 21, 35};

	// We initialize vector by giving it the starting point and 'one past' ending point of arrayOfInts
	vector<int> iVec(&arrayOfInts[0], &arrayOfInts[0] + intArraySize);

	for (vector<int>::const_iterator cvi = iVec.begin(); cvi != iVec.end(); ++cvi)
		cout << *cvi << endl;

	return 0;
}