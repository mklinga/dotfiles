// Ex 1.18 : range of two

#include <iostream>

int main()
{
	std::cout << "Give two numbers, and I'll do the magic." << std::endl;
	int v1,v2;
	std::cin >> v1 >> v2;

	int smaller = (v1 > v2)? v2 : v1;
	int larger = (v1 > v2)? v1 : v2;

	for (int i=smaller; i <= larger; ++i)
	{
		std::cout << i;
		if (i < larger)
		{
			std::cout << ", ";
		}
		else
		{
			std::cout << std::endl;
		}
	}

	return 0;
}