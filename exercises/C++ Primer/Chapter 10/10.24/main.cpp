// Ex 10.24: stripping the plurals

#include "../../helpers.h"

int main()
{
	ifstream pluralDefinitions("plurals");
	istream *inputStream;
	set<string> exceptions;
	string s; // helper string

	// we read from cin if file can't be opened properly
	if (!pluralDefinitions)
	{
		cout << "No plural definitions! Please type in some." << endl;
		inputStream = &cin;
	}
	else
		inputStream = &pluralDefinitions;

	while (*inputStream >> s)
		exceptions.insert(s);

	if (!cin.good())
		cin.clear(); // must clear this for it's used in next loop again!

	cout << "Give some plural to strip." << endl;
	cout << " > " << flush;
	while (cin >> s)
	{
		cout << " # Singular form of " << s << " is ";

		if (exceptions.find(s) != exceptions.end())
			cout << s << endl;
		else if (s.at(s.size()-1) != 's')
			cout << "a true mystery." << endl;
		else
			cout << s.erase(s.size()-1, 1) << endl;

		cout << "Give some plural to strip." << endl;
		cout << " > " << flush;
	}

	if (pluralDefinitions.is_open())
		pluralDefinitions.close();

	// save plurals for next time
	ofstream outToFile("plurals");

	set<string>::iterator exceptionIter = exceptions.begin();
	while (exceptionIter != exceptions.end())
			outToFile << *exceptionIter++ << " ";

	if (outToFile.is_open())
		outToFile.close();

	return 0;
}