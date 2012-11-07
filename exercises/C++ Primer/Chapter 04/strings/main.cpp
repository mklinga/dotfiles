// Strings - c and c++

#include "../Ch4headers.h"

int main()
{
	// C-style charactes string implementation
	const char *pc = "a very long literal string";
	const size_t len = strlen(pc + 1); // space to allocate

	// performance test on string allocation and copy
	for (size_t ix = 0; ix != 1000000; ++ix)
	{
		char *pc2 = new char[len + 1]; 	// allocate the space
		strcpy(pc2, pc); 				// do the copy
		if (strcmp(pc2, pc) != 0)		// use the new string
			; // do nothing
		delete [] pc2; 					// free the memory
	}

	// String implementation
	string str("a very long literal string");
	
	// performance test on string allocation and copy
	for (int ix = 0; ix != 1000000; ++ix)
	{
		string str2 = str; 				// do the copy, automatically allocated
		if (str != str2) 				// use the new string
			; // do nothing
	} 									// str2 is automatically freed

	return 0;
}