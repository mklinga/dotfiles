// Ex 10.8: map iterators

#include "../../helpers.h"

int main()
{
	map<string, string> myMap;
	myMap["second hand"] = "washes the other";

	map<string, string>::iterator myMapIter = myMap.begin();
	cout << myMapIter->first << ": " << myMapIter->second << endl;

	myMapIter->second = "is not here anymore";
	cout << myMapIter->first << ": " << myMapIter->second << endl;

	return 0;
}