// Ex 6.27: explain this loop

#include "../Ch6headers.h"

int main()
{
	string s;
	string sought("this");

	while (cin >> s && s != sought)
		; // empty body

	assert(cin); // assert fails if loop ended with ctrl+d (and not the sought word)
	cout << "Continuing with the daily business... " << endl;

	return 0;
}