// Ex 3.05: reading input as line/word

#include <iostream>
#include <string>
using std::cout;
using std::cin;
using std::endl;
using std::string;

void readLines()
{
	string line;

	// read line at a time, then print it
	cout << "Feed me lines!" << endl;
	while (getline(cin,line))
		cout << line << endl;

	return;
}

void readWords()
{
	string word;

	// read with single words
	cout << "Very well. Now some more!" << endl;
	while (cin >> word)
		cout << word << endl;
	
	return;
}

int main()
{
	//readLines();
	readWords();

	return 0;
}