// Ex 4.23: surfing in strings

#include "../Ch4headers.h"

int main()
{
	// remember that *cp is a pointer to first item in char-array
	const char *cp = "C++ is quite fun.";

	// *cp eventually comes to \0 (NULL)
	while (*cp) {
		cout << *cp << endl;
		++cp;
	}

	return 0;
}