// Ex 11.01: algorithms - count

#include "../../helpers.h"

const int kSearchNumber = 3;

int main()
{
	vector<int> iVec { 1, 2, 3, 5, 3, 2, 2, 1 };

	vector<int>::difference_type appearances = count(iVec.begin(), iVec.end(), kSearchNumber); 

	cout << "There seems to be " << appearances << " appearances of number " << kSearchNumber << "." << endl;

	return 0;
}
