// playing with dinopointers

#include "../Ch4headers.h"

int main()
{
	/***  Pointers ***/

	int myImportantInteger = 72;
	int myUnimportantInteger = 27;
	int *pInt = &myImportantInteger;
	void *vInt = &myImportantInteger; // vInt holds the address of myImportantInteger
	*pInt = 70; // this changes the value of myImportantInteger
	pInt = &myUnimportantInteger; // change the pointer to another variable

	cout << "mII: " << myImportantInteger << ", *pInt: " << *pInt << endl;

	const double e = 2.73;
	const double *pe = &e; // const must be pointing to const
	const void *ce = &e; // this only holds the address of e
	
	// This is ok, but value of myImportantInteger can't be changed through const pointer!
	const int *cInt = &myImportantInteger; 

	
	/***  Pointers and arrays  ***/
	
	const size_t arraySize = 5;
	int ia[arraySize] = {2, 3, 4, 6, 8};

	int *ip = ia; // ip points to ia[0], both *ip and ip[0] give (and change) the value of ia[0]
	int *ipp = &ia[2]; // straight pointer to ia[2], note &-operator before array place
	int k = ipp[-1]; // this is same as ia[2 -1], so k gets value from ia[1]
	int last = *(ia + 4); // initializes last to 8, the value of ia[4] - note that last is not a pointer

	int *lastPointer = ip + arraySize; // lastPointer points one past the end of array!

	for (int *beginPointer = ia; beginPointer != lastPointer; ++beginPointer) 
		cout << *beginPointer  << endl;

	return 0;
}