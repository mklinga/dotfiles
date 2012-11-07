// Ex 8.06: files and streams

#include "../Ch8Headers.h"

istream &print(istream &is)
{
	cout << "In the beginning stream is " << ((is.good())? "good." : "bad!") << endl << "Start: " << std::flush;

	try
	{
		std::string i;
		while (is >> i, !is.eof() && is.good())
			cout << i << endl;

		if (is.eof())
			throw std::runtime_error("eof");
		else 
			throw std::runtime_error("something went wrong");
	}
	catch (std::runtime_error e)
	{
		cout << "[" << e.what() << "]" << endl;
	}

	is.clear(); // clear stream back to 'clean' state

	return is;
}

int main()
{
	std::ifstream inputFile;

	// load file "testfile" from current working directory!
	inputFile.open("testfile");
	// print it out (note that argument for print is istream&)
	print(inputFile);
	// close the file
	inputFile.close();

	return 0;
}