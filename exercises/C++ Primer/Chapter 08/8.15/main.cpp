// Ex 8.15: stringstreams (derived from 8.03-04)

#include "../Ch8Headers.h"

istream &print(istream &is)
{
	try
	{
		string i;
		while (is.good())
		{
			is >> i;
			if (i != "")
				cout << i << endl;
		}

		if (is.eof())
			throw std::runtime_error("EOF");
		else 
			throw std::runtime_error("UNEXPECTED ERROR");
	}
	catch (std::runtime_error e)
	{
		cout << "[" << e.what() << "]" << endl;
	}

	is.clear();

	return is;
}

int main()
{
	std::istringstream myStringStream("this is a string");

	print( print(myStringStream));

	return 0;
}