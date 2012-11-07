// Ex 11.02: ex11.01 with list
// Point of this exercise is to show how same count() function works with list and vector
// with no other adjustments than base types of element container and difference_type

/***** requires -std=c++0x *****/

#include "../../helpers.h"

const int kSearchNumber = 3;

int main()
{
	list<int> iVec { 1, 2, 3, 5, 3, 2, 2, 1 };
	list<int>::difference_type appearances = count(iVec.begin(), iVec.end(), kSearchNumber); 

	cout << "There seems to be " << appearances << " appearances of number " << kSearchNumber << "." << endl;

	return 0;
}
