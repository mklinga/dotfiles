// Ex 2.11 : power of input

#include <iostream>

int main()
{
	int base, exponent, result=1;

	std::cout << "Please give a base number and an exponent" << std::endl;
	std::cin >> base >> exponent;

	for (int i=1; i <= exponent; i++)
	{
		result = result*base;
		std::cout << base << "^" << i << " = " << result << std::endl;
	}

	return 0;
}