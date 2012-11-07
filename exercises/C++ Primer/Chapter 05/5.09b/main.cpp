// Ex 5.09 (II): bitoperations

#include "../Ch5headers.h"

int main()
{
	unsigned long ul1 = 3; // bitwise: 00...00011
	unsigned long ul2 = 7; // bitwise: 00...00111

	unsigned long ul3 = ul1 & ul2;
	cout << "ul3: " << ul3 << endl;

	unsigned long ul4 = ul1 && ul2;
	cout << "ul4: " << ul4 << endl;

	unsigned long ul5 = ul1 | ul2;
	cout << "ul5: " << ul5 << endl;

	unsigned long ul6 = ul1 || ul2;
	cout << "ul6: " << ul6 << endl;

	return 0;
}