// Ex 3.10: Removing punctuation from string.

#include "../Ch3headers.h"

int main()
{
	string s("This! has!\"#%&_()=/-><<|, some, punctuation.- .issues.");
	string noPunct;

	for (string::size_type i = 0; i != s.size(); ++i)
	{
		if (!ispunct(s[i])) {
			noPunct += s[i];
		}
	}

	cout << noPunct << endl;

	return 0;
}