// Ex 4.08: comparing arrays

#include "../Ch4headers.h"

int main()
{
	const size_t arrayMax = 4;
	srand(time(NULL)); // seed rand()

	cout << "* Our story begins with two arrays. *" << endl;
	int ar1[arrayMax], ar2[arrayMax];

	for (size_t ai=0; ai < arrayMax; ++ai)
	{
		ar1[ai] = rand()%2;
		ar2[ai] = rand()%2;
		cout << (ai+1) << ". " << ar1[ai] << "/" << ar2[ai] << endl;
	}

	bool error=FALSE;
	for (size_t i=0; i < arrayMax; ++i)
		if (ar1[i] != ar2[i]) {
			error=TRUE;
			cout << (i+1) << ". items are not equal!" << endl;
			break;
		}

	if (!error)
		cout << "Everything is equal!" << endl;

	return 0;
}