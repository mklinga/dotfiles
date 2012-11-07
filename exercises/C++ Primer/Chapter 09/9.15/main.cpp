// Ex 9.15: lists & iterators
// This program takes a set of strings and returns a small sequence from the 'middle'
// This is a rewrite of 9.14 with lists instead of vectors

#include "../../helpers.h"

const int kSequenceLength = 3;

int main()
{
	list<string> myStrings;
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
	list<string>::const_iterator first = myStrings.begin(), last = myStrings.end();

	// list doesn't suppor multiple add/subtractions at time
	while (before-- != 0)
		++first;

	while (after-- != 0)
		--last;

	// note that we can still use vector<string> here, even though iters are from list<string>!
	vector<string> mySequence(first, last);

	PrintVector(mySequence,false," ");

	return 0;
}