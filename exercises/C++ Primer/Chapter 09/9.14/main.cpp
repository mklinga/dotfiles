// Ex 9.14: vectors & iterators
// This program takes a set of strings and returns a small sequence from the 'middle'

#include "../../helpers.h"

const int kSequenceLength = 3;

int main()
{
	vector<string> myStrings;
	cout << "Please give at least " << kSequenceLength << " strings (ctrl+d ends)" << endl;

	string s;
	while (cin >> s)
		myStrings.push_back(s);
		
	if (myStrings.size() < kSequenceLength)
	{
		cout << endl << "I said " <<  kSequenceLength << ", dumbass" << endl;
		return -1;
	}

	// we'll take sequence of given strings so that there is twice as much words before than after sequence
	unsigned amount = (myStrings.size() - kSequenceLength);

	unsigned after = (2*amount/3);
	unsigned before = amount - after;

	cout << "before: " << before << ", after: " << after << endl;
	vector<string>::const_iterator first = myStrings.begin() + before, last = myStrings.end() - after;

	vector<string> mySequence(first, last);

	PrintVector(mySequence,false," ");

	return 0;
}