// Ex 9.

#include "../../helpers.h"

int main()
{
	// number of elements we'll put in our stack
	const stack<int>::size_type stk_size = 10;
	stack<int, vector<int> > intStack; // empty stack
	// fill up the stack
	int ix = 0;
	while (intStack.size() != stk_size)
		// use postfix increment; want to push old value onto intStack
		intStack.push(ix++); // intStack holds 0...9 inclusive
	int error_cnt = 0;
	// look at each value and pop it off the stack
	while (intStack.empty() == false) {
		int value = intStack.top();
		// read the top element of the stack
		if (value != --ix) {
			cerr << "oops! expected " << ix
				 << " received " << value << endl;
			++error_cnt; }
		intStack.pop(); // pop the top element, and repeat
	}
	cout << "Our program ran with "
		 << error_cnt << " errors!" << endl;
	return 0;
}