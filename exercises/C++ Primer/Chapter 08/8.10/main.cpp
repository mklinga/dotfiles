// Ex 8.10: ex8.09, with word/element

#include "../Ch8Headers.h"

bool print_vector(vector<string> &s)
{
	for (vector<string>::const_iterator it = s.begin(); it != s.end(); ++it)
		cout << *it << endl;

	return true;
}

int main()
{
	std::ifstream input("myfile");
	vector<string> contents;

	//if the file is not ok, we'll quit
	if (!input)
	{
		std::cerr << "** WARNING: Couldn't open file!\n";
		return -1;
	}

	string s;
	while (input >> s)
		contents.push_back(s);

	input.close();// then close
	input.clear();// reset state to ok

	print_vector(contents);

	return 0;
}