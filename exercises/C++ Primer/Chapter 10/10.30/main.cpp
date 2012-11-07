// Ex 10.30: member functions of TextQuery

#include "../../helpers.h"
#include "../textquery.h"

void print_results(const set<TextQuery::line_no> &lineSet, const string &s, const TextQuery &tq)
{
	if (!lineSet.size())
	{
		cout << "No results for " << s << "." << endl;
		return;
	}

	cout << " ** Results ** " << endl;
	cout << s << " occurs " << lineSet.size() << " times." << endl;

	set<TextQuery::line_no>::const_iterator lineIter = lineSet.begin();

	while (lineIter != lineSet.end())
	{
		// we add one to *lineIter, since user propably wants lines to start from 1 instead of zero
		cout << "\t(line " << (*lineIter + 1) << ")\t" << tq.text_line(*lineIter) << endl;
		++lineIter;
	}

	return;
}

int main(int argc, char **argv)
{
	ifstream inFile;

	if (argc < 2 || !open_file(inFile, argv[1]))
	{
		cerr << "Fail: No input file." << endl;
		return EXIT_FAILURE;
	}

	TextQuery tq;
	tq.read_file(inFile); // builds query map

	while (true)
	{
		cout << "Enter a word to look for, or q to quit: ";
		string s;
		cin >> s;

		if (!cin || s == "q")
			break;

		set<TextQuery::line_no> locs = tq.run_query(s);

		print_results(locs, s, tq);
	}

	return 0;
}