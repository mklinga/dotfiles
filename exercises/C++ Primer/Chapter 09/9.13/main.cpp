// Ex 9.13: returning iters

#include "../Ch9Headers.h"
#include <cmath>

typedef vector<int>::const_iterator Iter;

Iter FindValue(Iter begin, Iter end, int value)
{
	Iter found;

	while (begin != end)
	{
		cout << *begin;

		if ((begin+1) != end && *begin != value)
			cout << ", ";
		
		if (*begin == value)
			return begin;

		++begin;
	}

	return begin;
}

int main()
{
	srand(time(0));
	vector<int> iVec;

	int attempts = 1+rand()%20;
	int possibilities = 2+rand()%20;
	int wantedValue = rand()%possibilities;
	double probs = 1-pow((1-(1.0/possibilities)),attempts);

	cout << "Looking for number " << wantedValue << " of " << possibilities 
		 << " with " << attempts << " attempts. Chances are about " << probs << "." << endl;

	for (vector<int>::size_type is = 0; is != attempts; ++is)
		iVec.push_back(rand()%possibilities);

	Iter wantedValueIter = FindValue(iVec.begin(), iVec.end(), wantedValue);

	if (wantedValueIter != iVec.end())
		cout << "! Value found!" << endl;
	else
		cout << ". No luck this time." << endl;

	return 0;
}