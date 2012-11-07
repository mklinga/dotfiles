// Ex 9.17: reading a list of strings

#include "../../helpers.h"

int main()
{
	list<string> myList;

	// populate list with some strings
	string ex[] = {"first", "second", "let", "me", "sing" };
	myList.insert( myList.begin(), ex, ex+5); // ex+5 is 'one-past-end' reference

	// recycle them through listValue, see-out it, and pop off the myList
	list<string>::value_type listValue;
	while (myList.size())
	{
		listValue = myList.front();
		cout << listValue << endl;
		myList.pop_front();
	}

	return 0;
}