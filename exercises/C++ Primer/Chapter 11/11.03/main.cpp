// Ex 11.03: accumulator

#include "../../helpers.h"

int main()
{
	vector<int> iVec;
	PopulateIntVector(iVec, 10, 10);

	cout << "Vector has following elements: " << flush;
	PrintVector(iVec); 
	cout << "Sum of elements minus five is " << accumulate(iVec.begin(), iVec.end(), -5) << endl;

	return 0;
}