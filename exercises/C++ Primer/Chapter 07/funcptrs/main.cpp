// function pointers

#include "../Ch7Headers.h"

typedef bool (*FuncPointer)(int &, int &);

bool function(int &a, int &b) { return ((a+b)%2 == 0); }
bool curiousFunction(bool (*p)(int &, int &))
{
	int a = 4, b = 8;
	cout << "curious! It seems to be " << (((*p)(a,b))? "true" : "false") << endl;
	return false;
}

int main()
{
	int a = 1, b = 2, c = 3;
	
	// pointer with above typedef
	FuncPointer fp = &function;

	// function pointer without typedef looks a bit complicated
	bool (*fp2)(int &, int &) = &function;

	// all these lines call same function()
	cout << ((*fp)(a,b)? "y" : "n") << endl;
	cout << (fp(a,c)? "y" : "n") << endl;
	cout << (function(b,c)? "y" : "n") << endl;
	cout << (fp2(a,c)? "y" : "n") << endl;

	// we can also send functionpointers as arguments
	curiousFunction(fp);

	return 0;
}