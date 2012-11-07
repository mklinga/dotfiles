// Ex 5.30: erroneous syntaxes

#include "../Ch5headers.h"

int main()
{
	vector<string> svec(10); // svec consist of 10 empty strings
	vector<string> *pvec1 = new vector<string>(10);
	vector<string> *pvec2 = new vector<string>[10];
	vector<string> *pv1 = &svec;
	vector<string> *pv2 = pvec1;

	delete pvec1;
	delete [] pvec2;
	// delete pv1; // error: svec is a local variable
	// delete pv2; // since pv2 points to same place than pvec1, we can't delete it second time

	return 0;
}