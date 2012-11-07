// Ex 5.19: legal expressions, 'aight

#include "../Ch5headers.h"

int main()
{
	vector<string> sVec;

	cout << "Please give at least three words." << endl;

	string s;
	while (cin >> s)
		sVec.push_back(s);

	vector<string>::iterator sVecIter = sVec.begin();

	// see-outs first item in sVec, and moves iter to next one
	cout << *sVecIter++ << endl;

	// finds out if the string iterator points to (2. word now) is empty
	cout << sVecIter->empty() << endl;

	// same iter as previous, after couting move to next
	cout << sVecIter++->empty() << endl;


	return 0;
}