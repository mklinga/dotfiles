// Ex 9.40: assign/append

#include "../../helpers.h"

int main()
{
	string q1("When lilacs last in the dooryard bloom'd");
	string q2("The child is father of the man");

	string sentence;

	sentence.assign(q2, 0, 13); // The child is 
	sentence.append(q1, q1.find("in the dooryard"), 15); // in the dooryard

	cout << sentence << endl;

	return 0;
}