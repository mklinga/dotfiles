// Ex 5.04: overflow

#include "../Ch5headers.h"

int main()
{
	// flowing over!
	short i = 32767;
	i += 2;

	cout << i << endl;

	const char *cp = "Hello";

	return 0;
}