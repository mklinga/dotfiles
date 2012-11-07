// Ex 4.25: comparing strings, two styles

#include "../Ch4headers.h"

int main()
{
	const char *cp = "C++ is quite fun.", *cp2 = "C++ is quite fun.";
	string s1 = "C++ is quite fyn.", s2 = "D-- is even more fyn.";

	if (s1 == s2) { cout << "S1 is same as s2!" << endl; }
	else { cout << "Strings differ some." << endl; }

	if (strcmp(cp, cp2) == 0) {
		cout << "C-strings are equal!" << endl; 
	}
	else {
		cout << "C-strings differ." << endl;
	}

	return 0;
}