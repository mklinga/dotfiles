// Ex 3.07: Playing with strings

#include <iostream>
#include <string>
using std::string;
using std::cout;
using std::cin;
using std::endl;

int main()
{
	string plea("Please give me two strings."), s1, s2, result;
	cout << plea << endl;

	cout << "1) ";
	getline(cin,s1);
	cout << "2) ";
	getline(cin,s2);

	if (s1 == s2) {
		result = "Strings seem to be equal.\n";
	}
	else {
		result = "String \"" + ((s1 > s2)? s1 : s2)+ "\" seems to be larger.\n";
	}

	if (s1.size() == s2.size()) {
		result += "Strings are equally long.";
	}
	else {
		result += "String \"" + ((s1.size() > s2.size())? s1 : s2) + "\" seems to be longer.";
	}

	cout << result << endl;

	return 0;
}