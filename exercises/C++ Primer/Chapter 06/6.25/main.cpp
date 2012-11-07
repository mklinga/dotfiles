// Ex 6.25: revisiting, now with debug information

//#define NDEBUG // this must be BEFORE including <cassert>

#include "../Ch6headers.h"

int main()
{
	cout << "Please give me words" << endl;
	string s, last("");

	while (cin >> s)
	{
		// fail on uppercase starting letters when debugging
		assert(!isupper(s[0]));

		if (s == last)
		{ 
#ifndef NDEBUG
			cerr << s << " == " << last << endl;			
#endif
			break;
		}
		else
			last = s; 
	}

	if (s == last)
		cout << "Found a repeating word: " << last << endl;

	return 0;
}