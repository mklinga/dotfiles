// Ex 9.24: fetching the first element of vector

#include "../../helpers.h"

int main()
{
	vector<int> iVec(1,1), iVecEmpty;

	vector<int>::reference iVecReference1 = iVec.front();
	vector<int>::reference iVecReference2 = *iVec.begin();
	vector<int>::reference iVecReference3 = iVec[0];
	vector<int>::reference iVecReference4 = iVec.at(0);

	cout << iVecReference1 << endl;
	cout << iVecReference2 << endl;
	cout << iVecReference3 << endl;
	cout << iVecReference4 << endl;

	try 
	{
		iVecReference4 = iVecEmpty.at(2); // all the other methods are run-time-errors ('undefined')
	}
	catch (exception &e)
	{
		cout << "ERROR: " << e.what() << endl;
	}

	return 0;
}