// Ex 10.13: map+insert

#include "../../helpers.h"

int main()
{
	map<string, vector<int> > myMap;
	string firstKey = "Aardvark";
	vector<int> aardvarkFrequency(10,2);

	pair< map<string, vector<int> >::iterator, bool> returnValue = myMap.insert(make_pair(firstKey, aardvarkFrequency));
	cout << returnValue.first->first << ": " << ((returnValue.second)? ("Added") : ("Already there")) << endl;
	returnValue = myMap.insert(make_pair(firstKey, aardvarkFrequency));
	cout << returnValue.first->first << ": " << ((returnValue.second)? ("Added") : ("Already there")) << endl;

	cout << myMap.begin()->first << ": ";
	PrintVector(myMap.begin()->second);

	return 0;
}