// Ex 4.09: 10 ints

#include "../Ch4headers.h"

int main()
{
	int array[10];

	for (size_t ai=0; ai < 10; ++ai){
		array[ai] = ai;
		cout << ai << ") " << array[ai] << endl;
	}

	return 0;
}