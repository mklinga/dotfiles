// Ex 10.01: pairs and vectors

#include "../../helpers.h"

int main()
{
	cout << "Please give a serie of strings and/or ints or anything." << endl;
	vector< pair<string, string> > pairVector;

	string firstString, lastString;
	while (cin >> firstString >> lastString)
	{
		pair< string, string > nextPair(firstString, lastString);
		pairVector.push_back(nextPair);
	}

	cout << "There are " << pairVector.size() << " elements in vector" << endl;

	return 0;
}