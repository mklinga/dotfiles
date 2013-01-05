/*										
 * helpers.cpp	
 * (c) Markus Klinga
 * 
 */

#include "helpers.h"
#include <ctime>

std::string Helpers::ParseShortTime(long seconds)
{
	std::string helper("");
	int firstFound = 100;

	if (seconds < 0)
	{
		seconds *= (-1);
		helper += "-";
	}

	if (seconds > 365*24*60*60) {
		helper += std::to_string(seconds/(365*24*60*60)) + "y ";
		seconds %= (365*24*60*60);
		firstFound = 1;
	}
	if (seconds > 30*24*60*60) {
		helper += std::to_string(seconds/(30*24*60*60)) + "m ";
		seconds %= (30*24*60*60);
		firstFound = std::min(firstFound, 2);
	}
	if ((seconds > 24*60*60) && (firstFound > 1)) {
		helper += std::to_string(seconds/(24*60*60)) + "d ";
		seconds %= (24*60*60);
		firstFound = std::min(firstFound, 3);
	}

	if (Global::Config.GetAppOptions().useShortTimeFormat)
	{
		if (seconds > 0)
		{
			helper += Helpers::AddLeadingZero(std::to_string((seconds/(60*60)))) + ":";
			seconds %= (60*60);
			helper += Helpers::AddLeadingZero(std::to_string((seconds/(60)))) + ":";
			seconds %= (60);
			helper += Helpers::AddLeadingZero(std::to_string(seconds));
		}
	}
	else
	{
		if ((seconds > 60*60) && (firstFound > 2)) {
			helper += std::to_string(seconds/(60*60)) + "h ";
			seconds %= (60*60);
			firstFound = std::min(firstFound, 4);
		}
		if ((seconds > 60) && (firstFound > 3)) {
			helper += std::to_string(seconds/(60)) + "min ";
			seconds %= (60);
			firstFound = std::min(firstFound, 5);
		}
		if ((seconds > 0) && (firstFound > 4)) {
			helper += std::to_string(seconds) + "s";
		}
	}

	if (helper.size() == 0)
		helper = "0s";
	else if (*helper.rbegin() == ' ') // remove trailing space
		helper = helper.substr(0, helper.size()-1);

	return helper;
}

std::string Helpers::ParseLongTime(std::chrono::system_clock::time_point timePoint)
{
	std::time_t temp = std::chrono::system_clock::to_time_t(timePoint);

	std::string formattedString = ctime(&temp);
	return formattedString.substr(0, formattedString.length() - 1); // remove \n from the end
}

std::string Helpers::TruncateToString(double number, unsigned int prec)
{
	std::ostringstream ss;
	ss << std::fixed << std::setprecision(prec) << number;
	return ss.str();
}

std::string Helpers::AddLeadingZero(std::string originalString)
{
	if (originalString.size() == 1)
		return std::string(1,'0').append(originalString);
	else 
		return originalString;
}

std::string Helpers::GiveTimeFrameType(int timeFrame)
{
	std::vector<std::string> goalNames { "day", "week", "month"};

	if (goalNames.size() > timeFrame)
		return goalNames.at(timeFrame);
	else
		return "[unknown]";
}

int Helpers::GetTimeFrameModifier(int timeFrame)
{
	std::vector<int> modifiers { 1, 7, 30 };
	
	if (modifiers.size() > timeFrame)
		return modifiers.at(timeFrame);
	else
		return 1;
}

std::string Helpers::GetParsedSince(std::chrono::system_clock::time_point then)
{
	return Helpers::ParseShortTime(Helpers::GetSecondsSince(then));
}

long Helpers::GetSecondsSince(std::chrono::system_clock::time_point then)
{
	std::chrono::duration<double> timeAgo = std::chrono::duration_cast< std::chrono::duration<double> >(std::chrono::steady_clock::now() - then);
	
	return timeAgo.count();
}

