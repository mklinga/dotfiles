// Ex 3.13: Tiny integers in a vector

#include "../Ch3headers.h"

int main()
{
	vector<int> iVec;
	cout << "* Please give some numbers separated by space (Ctrl+d exits)*" << endl;

	int s;
	while (cin >> s)
		iVec.push_back(s);

	// print adjancent pairs' sums
	for (vector<int>::size_type i = 0; i < (iVec.size()-1); i += 2)
		cout << iVec[i] << " + " << iVec[i+1] << " = " << iVec[i]+iVec[i+1] << endl;

	// print sums for first+last, second+second last etc.
	for (vector<int>::size_type i = 0; i < (vector<int>::size_type)(iVec.size()/2); i ++)
		cout << iVec[i] << " + " << iVec[iVec.size()-(1+i)] << " = " << iVec[i]+iVec[iVec.size()-(1+i)] << endl;
	
	// print last item, if it's forever alone (odd amount)
	if (iVec.size()%2 != 0)
		cout << "Last (odd) number: " << iVec[iVec.size()-1] << endl;

	return 0;
}