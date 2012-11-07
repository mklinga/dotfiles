// Ex 6.19: rewriting in succinct!

#include "../Ch6headers.h"

int main()
{
	vector<int> vec(4,4);
	vec.push_back(12);
	vec.push_back(15);
	vec.push_back(16);

	int value = 12;
	vector<int>::iterator iter = vec.begin();
	while (*iter != value && ++iter != vec.end()) 
		; // no body necessary, everything's done in condition

	cout << "Last checked item was: " << *iter << endl;

	return 0;
}