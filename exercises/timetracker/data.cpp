/*										
 * data.cpp	
 * (c) Markus Klinga
 * 
 * Definition of DataBase class
 */

#include <iostream>
#include <ctime>
#include <ratio>

#include "log.h"
#include "data.h"
#include "treedata.h"
#include "config.h"


/*
 *  UniqueID
 */


UniqueID::UniqueID():
	_lastID(0),
	_amountOfIDs(0)
{
	Log.Add("UniqueID holder created");
}

unsigned int UniqueID::GenerateID()
{
	// by default give next integer
	unsigned int newID;

	// if something has been released we'll use that instead
	if (_releasedIDs.size() > 0)
	{
		std::set<unsigned int>::iterator releasedIter = _releasedIDs.begin();
		newID = *releasedIter;
		_releasedIDs.erase(releasedIter);

		Log.Add("Got UniqueId from _releasedIDs: " + std::to_string(_releasedIDs.size()) + " left");
	}
	else
	{
		newID = ++_lastID;
	}

	return newID;
}

void UniqueID::ReleaseID(unsigned int newlyReleasedID)
{
	// _releasedIDs takes care of possible duplicates by being a std::set
	_releasedIDs.insert(newlyReleasedID);
}


/*
 *  DataItem
 */


DataItem::DataItem():
	ID(0), name("[empty]"), description("[empty]"), percentage(0), continuous(false), inverse(false), 
	times(0), elapsedTime(0), goalTime(0)
{

}

/*
 *  DataBase
 */


DataBase::DataBase()
{
	_Load();
}

DataBase::~DataBase()
{
	_Save();
}

void DataBase::_Load()
{
	std::vector<DataItem> loadedData = Config.GetSavedData();

	for (std::vector<DataItem>::iterator dataIter = loadedData.begin();
			dataIter != loadedData.end(); ++dataIter)
		AddItemToDataBase(*dataIter);

	Log.Add("Loaded " + std::to_string(_data.size()) + " items");

}

void DataBase::_Save()
{

}

void DataBase::AddItemToDataBase(DataItem &item)
{
	unsigned int newID = _uniqueID.GenerateID();
	Log.Add("Added item " + std::to_string(newID) + ". " + item.name);

	item.ID = newID; // we don't care if DataItem already has an ID
	_data.insert(std::make_pair(newID, item));
}

void DataBase::RemoveItemFromDataBase(unsigned int removableID)
{
	_data.erase(removableID);
	_uniqueID.ReleaseID(removableID);
}

int DataBase::GetSize()
{
	return _data.size();
}

bool DataBase::IsIn(unsigned int ID)
{
	return (_data.find(ID) != _data.end());
}

DataItem& DataBase::GetItem(unsigned int ID)
{
	return _data.find(ID)->second;
}

DataItem& DataBase::GetItem(std::map<unsigned int, DataItem>::iterator wanted)
{
	return wanted->second;
}

// Get specific DataItem from DataBase
DataItem* DataBase::GetIDDataCopy(unsigned int ID)
{
	std::map<unsigned int, DataItem>::iterator wantedIDIter = _data.find(ID);
	Log.Add("Looking for ID = " + std::to_string(ID));

	if (wantedIDIter != _data.end())
		return &wantedIDIter->second;
	else
	{
		Log.Add("ID = " + std::to_string(ID) + " was Not Found!");
		return NULL;
	}
}

const std::map<unsigned int, DataItem>& DataBase::GetData()
{
	return _data;
}
