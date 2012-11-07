// Ex 3.17: rewrite of 3.13 with iterators

#include "../Ch3headers.h"

int main()
{
	vector<int> iVec;
	cout << "* Please give some numbers separated by space (Ctrl+d exits)*" << endl;

	int s;
	while (cin >> s)
		iVec.push_back(s);

	// helper iter for *iter+1
	vector<int>::const_iterator iterPlusOne = iVec.begin() + 1;

	// print adjancent pairs' sums
	for (vector<int>::const_iterator iter = iVec.begin(); iter < iVec.end(); iter += 2)
	{
		if (iterPlusOne < iVec.end()) // if we're still in vector
		{
			cout << *iter << " + " << *iterPlusOne << " = " << (*iterPlusOne+*iter) << endl;
			iterPlusOne += 2;
		}
		else {
			cout << "Odd item: " << *iter << endl; 
		}
	}

	// print sums for first+last, second+second last etc.
	// create a helper iter that points to the last actual object in iVec
	vector<int>::const_iterator backwardsIter = iVec.begin() + (iVec.size() - 1);

	for (vector<int>::const_iterator iter = iVec.begin(); iter < (iVec.begin() + (iVec.size()/2)); ++iter)
	{
		cout << *iter << " + " << *backwardsIter << " = " << (*iter+*backwardsIter) << endl;
		--backwardsIter;
	}

	if (iVec.size()%2 != 0)
		cout << "Odd item: " << *backwardsIter << endl;

	return 0;
}