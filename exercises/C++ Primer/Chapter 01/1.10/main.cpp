// Ex 1.10 : numbers 50->100

#include <iostream>

int main()
{
	int sum = 0;

	for (int i = 50; i <= 100; ++i)
		sum += i;

	std::cout << "The sum for numbers from 50 to 100 seems to be " << sum << std::endl;
	std::cout << "Trying to figure it out with \"while\"" << std::endl;

	int i = 50;
	sum = 0;
	while (i <= 100)
	{
		sum += i;
		++i;
	}

	std::cout << "Sum with while is " << sum << std::endl;
	return 0;
}