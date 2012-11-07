// Ex 4.30: concatenating strings, C-style

#include "../Ch4headers.h"

int main()
{
	const char *sl1 = "This is first string";
	const char *sl2 = " and this is second.";

	int totalLength = strlen(sl1) + strlen(sl2);

	char *newStringLiteral = new char[totalLength];
	char *cl1 = newStringLiteral; // we modify newStringLiteral through this pointer

	while (*sl1) {
		*cl1 = *sl1;
		++cl1; ++sl1;
	}
	while (*sl2) {
		*cl1 = *sl2;
		++cl1; ++sl2;
	}

	*cl1 = '\0'; // indicate that our new string ends here
	cl1 = &newStringLiteral[0]; // return pointer to start for printout

	while (*cl1) {
		cout << *cl1;
		++cl1;
	}

	// and some cleaning
	delete [] newStringLiteral;
	cout << endl;

	return 0;
}