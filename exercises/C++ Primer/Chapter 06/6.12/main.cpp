// Ex 6.12: small program that finds repeated words

#include "../Ch6headers.h"

int main()
{
	cout << "Please give some words, preferably repeating some of them." << endl;

	vector<string> sVec;
	string s;
	while (cin >> s)
		sVec.push_back(s);

	vector<string>::const_iterator sIter = sVec.begin();
	string last(""), largestWord("No words were repeated");
	int num = 0, largestAmount = 1;
	while (sIter != sVec.end())
	{
		if (last != *sIter)
		{
			last = *sIter;
			num = 1;
		}
		else 
			++num;

		if (num > largestAmount)
		{
			largestWord = *sIter;
			largestAmount = num;
		}
		
		++sIter;
	}

	cout << "*** STATS *** " << endl;
	cout << "Most occurances: " << largestAmount << endl;
	cout << "Most frequent word: " << largestWord << endl;

	return 0;
}