// Ex 1.11 : From ten to zero

#include <iostream>

int main()
{
	int i = 10;
	while (i >= 0)
	{
		std::cout << i << std::endl;
		--i;
	}

	// and the same with 'for'
	for (int j = 10; j >= 0; --j)
		std::cout << j << std::endl;

	return 0;
}