// Ex 1.16 : Larger of two

#include <iostream>

int main()
{
	std::cout << "Give two numbers, please!" << std::endl;
	int v1, v2;
	std::cin >> v1 >> v2;

	std::cout << "Larger number seems to be : ";
	if (v1 >= v2)
	{
		std::cout << v1;
	}
	else
	{
		std::cout << v2;
	}

	std::cout << std::endl;

	return 0;
}