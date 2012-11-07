// String-fun

#include "../../helpers.h"

int main()
{
	char characterArray[] = "I can do this.";
	string s2("wonder");

	string s(characterArray, 6, 2);
	s.insert(s.end(), characterArray+5, characterArray+8);
	s.insert(s.end(), 3, '.');

	s.insert(s.size(), s2);
	s.append("woman");
	s.push_back('-');
	s.insert(s.size(), s.substr(s.size()-4, 3));
	
	cout << s << endl;

	string::size_type pos = s.find("wonderwoman");
	s.replace(pos, 11, "batman");

	cout << s << endl;

	return 0;
}