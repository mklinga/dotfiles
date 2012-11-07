// Ex 1.19 : range of two, divided 10/line

#include <iostream>

int main()
{
	std::cout << "Give two numbers, and I'll do the magic." << std::endl;
	int v1,v2;
	std::cin >> v1 >> v2;

	int smaller = (v1 > v2)? v2 : v1;
	int larger = (v1 > v2)? v1 : v2;

	// This is a comment, it's quite bright
	for (int i=smaller; i <= larger; ++i)
	{
		std::cout << i;

		//end lines after 10 items or 'last'
		if (((i-(smaller-1))%10 == 0) or (i == larger)) 
		{
			std::cout << std::endl;
		}
		else if (i < larger)
		{
			std::cout << ", ";
		}
	}

	return 0;
}