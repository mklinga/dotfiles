// Ex 3.18: Twice the value, thrice the fun

#include "../Ch3headers.h"
#include <cstdlib>

int main()
{
	vector<int> iVec;

	for (int i=0; i<10; ++i)
		iVec.push_back(rand()%100);

	cout << "* Original numbers *" << endl;
	for (vector<int>::const_iterator cIter = iVec.begin(); cIter != iVec.end(); ++cIter)
		cout << *cIter << " ";

	cout << endl << "* Twice the numbers *" << endl;
	for (vector<int>::iterator cIter = iVec.begin(); cIter != iVec.end(); ++cIter)
	{
		*cIter *= 2;
		cout << *cIter << " ";
	}

	cout << endl;

	return 0;
}