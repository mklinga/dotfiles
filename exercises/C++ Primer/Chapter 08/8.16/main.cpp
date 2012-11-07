// Ex 8.16: reading files

#include "../Ch8Headers.h"

int main()
{
	vector<string> sVec;

	std::ifstream file("myfile");

	if (!file)
		return -1;

	string s;
	while (getline(file,s))
		sVec.push_back(s);

	vector<string>::const_iterator iter = sVec.begin();

	while (iter != sVec.end())
	{
		cout << "Line: " << *iter << " (";

		std::istringstream line(*iter);

		string word;
		while (line >> word)
		{
			cout << word;
			if (line.good())
				cout << " | ";
		}

		cout << ")" << endl;

		++iter;
	}

	file.close();

	return 0;
}