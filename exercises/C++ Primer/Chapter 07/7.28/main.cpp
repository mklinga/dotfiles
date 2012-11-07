// Ex 7.28: static variables

#include "../Ch7Headers.h"

size_t counter_function()
{
	static size_t counter = 0;

	// at first time, we return 0, on other times number of calls made (2, 3, 4, ...)
	return (counter? ++counter : counter++);
}

int main()
{
	cout << counter_function() << endl;

	for (int i = 0; i != 10; ++i)
		counter_function();

	cout << counter_function() << endl;

	return 0;
}