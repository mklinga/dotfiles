// Ex 5.11: assignments

#include "../Ch5headers.h"

int main()
{
	int i; double d;

	// both will be set to 3
	d = i = 3.5;
	cout << "i: " << i << ", d: " << d << endl;

	// d will be set 'correctly' to 3.5, i will still be 3
	i = d = 3.5;
	cout << "i: " << i << ", d: " << d << endl;

	d = ++i;
	cout << "i: " << i << ", d: " << d << endl;

	return 0;
}