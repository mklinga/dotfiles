// Ex 9.26: erasing elements, still

#include "../../helpers.h"

int main()
{
	vector<int> iVec;
	list<int> iList;
	int ex[11] = { 0, 1, 1, 2, 3, 5, 8, 13, 21, 55, 89 };
	PopulateIntVector(iVec, ex, ex + 10);
	iList.insert(iList.begin(), ex, ex+10);

	vector<int>::iterator vectorIter = iVec.begin();
	list<int>::iterator listIter = iList.begin();

	while (vectorIter != iVec.end())
	{
		if (*vectorIter%2 == 0)
			vectorIter = iVec.erase(vectorIter);
		else
			++vectorIter;
	}

	while (listIter != iList.end())
	{
		if (*listIter%2 != 0)
			listIter = iList.erase(listIter);
		else
			++listIter;
	}

	PrintVector(iVec);
	PrintList(iList);

	return 0;
}