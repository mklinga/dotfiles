// Ex 5.21: vectors and operators

#include "../Ch5headers.h"

int main()
{
	vector<int> iVec;
	srand(time(NULL));

	for (int i=0; i < 10; ++i)
		iVec.push_back(rand()%10);

	cout << "Some random, even values: ";
	// replace all odd values with 2*value
	for (vector<int>::iterator iVecIter = iVec.begin(); iVecIter != iVec.end(); ++iVecIter)
	{
		*iVecIter = (*iVecIter%2 == 0)? *iVecIter : (2* *iVecIter);
		cout << *iVecIter << " ";
	}

	cout << endl;

	return 0;
}