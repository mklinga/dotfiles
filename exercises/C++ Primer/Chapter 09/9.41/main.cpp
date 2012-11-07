// Ex 9.41: replace/strings

#include "../../helpers.h"

inline string greet(string &generic1, string &lastName, string &generic2, short pos, short len)
{
	return (generic1.replace(8, 5, lastName)).replace(5, 2, generic2, pos, len);
}

int main()
{
	string generic1("Dear Ms Daisy");
	string generic2("MrsMsMissPeople");

	string lastName("Klingasteri");
	string salute = greet(generic1, lastName, generic2, 9, 6);

	cout << salute << endl;

	return 0;
}