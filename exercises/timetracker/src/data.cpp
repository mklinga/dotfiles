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
		Log.Add("Generated new Unique id.");
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
	name("[empty]"), description("[empty]"), percentage(0), continuous(false), times(0),
	elapsedTime(0)
{

}

DataItem::DataItem(std::string pName, std::string pDescription, bool pContinuous, double pGoalTime):
	name(pName), description(pDescription), continuous(pContinuous), goalTime(pGoalTime), times(0),
	elapsedTime(0)
{
	percentage = 41;
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
	
	DataItem a("Trait A", "blah blah blah", true, 15);
	DataItem b("Trait B", "dalp dalp dalp", true, 500);
	DataItem c("Trait C", "blah blah blah", true, 15);
	DataItem d("Trait D", "dalp dalp dalp", false, 500);
	DataItem e("Trait E", "blah blah blah", true, 15);
	DataItem f("Trait F", "dalp dalp dalp", true, 500);

	AddItemToDataBase(a);
	AddItemToDataBase(b);
	AddItemToDataBase(c);
	AddItemToDataBase(d);
	AddItemToDataBase(e);
	RemoveItemFromDataBase(d.ID);
	AddItemToDataBase(f);

	Log.Add("Loaded " + std::to_string(_data.size()) + " items");

}

void DataBase::_Save()
{

}

void DataBase::AddItemToDataBase(DataItem &item)
{
	unsigned int newID = _uniqueID.GenerateID();
	Log.Add("Added item " + std::to_string(newID));

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

// Fill TreeView in MainWindow with data
void DataBase::PopulateTreeModel(Glib::RefPtr<Gtk::ListStore> &mrefTreeModel, ModelColumns &mColumns)
{
	//Fill the TreeView's model
	for (std::map<unsigned int, DataItem>::const_iterator iter = _data.begin(); iter != _data.end(); ++iter)
	{
		Gtk::TreeModel::Row row = *(mrefTreeModel->append());
		PopulateRow(row, mColumns, (*iter).second);
	}
}

void DataBase::PopulateRow(Gtk::TreeModel::Row &row, ModelColumns &mColumns, const DataItem &ditem)
{
	row[mColumns.columnID] = ditem.ID;
	row[mColumns.columnName] = ditem.name;
	row[mColumns.columnPercentage] = ditem.percentage;
	row[mColumns.columnElapsedTime] = ditem.elapsedTime;
	row[mColumns.columnGoalTime] = ditem.goalTime;
	
}

// Get specific DataItem from DataBase
DataItem DataBase::GetIDDataCopy(unsigned int ID)
{
	std::map<unsigned int, DataItem>::const_iterator wantedIDIter = _data.find(ID);
	Log.Add("Looking for ID = " + std::to_string(ID));

	if (wantedIDIter != _data.end())
		return wantedIDIter->second;
	else
	{
		Log.Add("ID = " + std::to_string(ID) + " was Not Found!");
		return DataItem(); // TODO: we shouldn' return anything unless specific id is found?
	}
}

