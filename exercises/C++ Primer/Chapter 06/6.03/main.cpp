// Ex 6.3: rewriting bookstoreproblem

#include "../Ch6headers.h"

int main()
{
	// an excerpt from bookstore problem, loosely
	char trans, total=0;

	while (cin >> trans)
		if (trans == 0)
			total = total + trans;
		else // replaced block with comma operator
			cout << total << endl, total = trans;

	return 0;
}