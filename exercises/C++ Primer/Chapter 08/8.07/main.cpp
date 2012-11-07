// Ex 8.07: multiple files and error handling

#include "../Ch8Headers.h"

void process(string &s)
{
	cout << s << endl;

	return;
}

int main()
{
	std::ifstream input;
	vector<string> files;

	string s[] = {"1st", "erroneousfile", "2nd", "3rd"};

	for (int i = 0; i < 4; ++i)
		files.push_back(s[i]);

	vector<string>::const_iterator iter = files.begin();

	while (iter != files.end())
	{
		input.open(iter->c_str()); // how cool is this :P

		//if the file is ok, we'll read it
		if (input)
		{
			string s;
			while (getline(input,s)) // read one line per loop
				process(s);

			// then close
			input.close();
		}
		else
		{
			std::cerr << "** WARNING: Bad file name '" << iter->c_str() << "'!\n";
		}

		// reset state to ok
		input.clear();
		// select next file in list (if there is one)
		++iter;
	}

	return 0;
}