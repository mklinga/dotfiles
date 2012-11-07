// Ex 9.28: assigning elements

#include "../../helpers.h"

int main()
{
	const char *str[] = { "Frst", "Scd", "Trd" };
	
	list<const char*> cStringList;
	cStringList.assign(str, str+3);

	vector<string> sVec;
	sVec.assign(cStringList.begin(), cStringList.end());

	// sVec now contains original contents of str[] - as strings!
	for (vector<string>::size_type i = 0; i < sVec.size(); ++i)
		cout << sVec.at(i).c_str() << endl; // we call c_str() just to emphasize this :)

	return 0;
}