// Ex 1.23 : multiple items' sum

#include <iostream>
#include "../sales_item.h"

int main()
{
	Sales_item current, total;

	std::cout << "Give items (format: ISBN amount price)" << std::endl;
	std::cin >> total;
	std::cout << "Added " << total << std::endl;

	while (std::cin >> current)
	{
		total += current;
		std::cout << "Added " << current << std::endl;
		std::cout << "Total: " << total << std::endl;
	}

	std::cout << " *** " << std::endl << "Total: " << total << std::endl;

	return 0;
}