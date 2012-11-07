// Ex 9.39: words in sentences

#include "../../helpers.h"

int main()
{
	string line1 = "We are her pride of 10 she named us";
	string line2 = "Benjamin, Phoenix, the Prodigal";
	string line3 = "and perspicacious pacific Suzanne";

	string sentence = line1 + ' ' + line2 + ' ' + line3;
	string::size_type pos = 0, lastPos = 0;
	short wordCount = 0, shortestWord, longestWord;
	short longestWordCount = 0, shortestWordCount = 0;
	bool valid = true;

	while (valid)
	{
		if ((pos = sentence.find_first_of(" ", pos)) == string::npos)
		{
			pos = sentence.size(); // we have to set last word manually
			valid = false; // end loop after this round
		}

		short lengthOfLast = (pos - lastPos);

		if (wordCount++ == 0)
		{
			shortestWord = longestWord = lengthOfLast;
			shortestWordCount = longestWordCount = 1;
		}
		else if (lengthOfLast > longestWord)
		{
			longestWord = lengthOfLast;
			longestWordCount = 1;
		}
		else if (lengthOfLast < shortestWord)
		{
			shortestWord = lengthOfLast;
			shortestWordCount = 1;
		}
		else if (lengthOfLast == longestWord)
			longestWordCount++;
		else if (lengthOfLast == shortestWord)
			shortestWordCount++;

		if (valid)
			lastPos = ++pos;
	}

	cout << "Total words: " << wordCount << endl;
	cout << "Shortest: " << shortestWord << " (" << shortestWordCount << ")" << endl;
	cout << "Longest: " << longestWord << " (" << longestWordCount << ")" << endl;

	return 0;
}