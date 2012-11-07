// String testing (just having a bit of fun)

#include <iostream>
#include <string>
using std::string;
using std::cout;
using std::endl;

int main()
{
	string s1("Example string");
	string s2;
	// This produces an error: can't add string literals
	// string s3 = "Hello" + "\n";

	s2 = s1 + "!";
	cout << s2 << endl;

	// No error here, since (from left to right) we always have a string operand to go with
	s1 = "This " + s2 + " is not so" + "\n";

	cout << s1 + "coo......ool" << endl;

	return 0;
}