// Ex 5.18: arrow - operator (array of pointers return)

#include "../Ch5headers.h"

int main()
{
	vector<string> sVec;
	vector<string*> sPtrVec;

	cout << "Please give some strings to me." << endl;

	string s;
	while (cin >> s)
		sVec.push_back(s);

	// We'll create pointers for each string
	for (vector<string>::size_type vI = 0; vI != sVec.size(); ++vI)
		sPtrVec.push_back(&sVec[vI]);

	// Note syntax on vStrIter:
	// **vStrIter <- we need two dereferences, since first one only gives us the pointer to string
	// (*vStrIter)->size  is same as writing (**vStrIter).size()
	for (vector<string*>::const_iterator vStrIter = sPtrVec.begin();	vStrIter != sPtrVec.end(); ++vStrIter)
		cout << "string: " << **vStrIter << " (size " << (*vStrIter)->size() << ")" << endl;

	return 0;
}