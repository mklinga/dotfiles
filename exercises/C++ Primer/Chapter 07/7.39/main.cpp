// Ex 7.39: function declarations, overloading

#include "../Ch7Headers.h"

int calc(int, int);
int calc(const int&, const int&);

int calc(char *a, char *b) { return 2*((*a)+(*b)); }
int calc(const char *a, const char *b) { return 1+2*((*a)+(*b));}

// this is error: redefinition of calc (char *,char *)
// (as it matters not that the pointer is defined as 'const', since it's copied, not referenced here)
// int calc(char* const, char* const);

int main()
{
	const char a = 2, b = 4;
	const char *pa = &a, *pb = &b;

	cout << calc(pa, pb) << endl;

	return 0;
}