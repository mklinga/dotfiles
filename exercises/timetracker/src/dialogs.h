/*										
 * dialogs.h	
 * (c) Markus Klinga
 * 
 * Handles all secondary windows
 */

#ifndef TIMETRACKER_DIALOGS_H
#define TIMETRACKER_DIALOGS_H

#include <gtkmm.h>

class DataItem;

class DataItemDialog : public Gtk::Dialog
{
	public:
		DataItemDialog();

		int LaunchDialog(DataItem *);

	private:

		Gtk::HBox _mainRow;
		Gtk::VBox _titleColumn;
		Gtk::VBox _widgetColumn;
		Gtk::Label _nameLabel;
		Gtk::Entry _nameEntry;

		Gtk::Label _descriptionLabel;
		Gtk::Entry _descriptionEntry;

		Gtk::CheckButton _inverseButton;

		Gtk::HBox _goalRow;
		Gtk::SpinButton _goalButton;
		Gtk::Label _goalLabel, _goalPerLabel;
		Gtk::ComboBoxText _goalType;
		Gtk::ComboBoxText _goalTimeFrame;

		void _FillDialogValues(DataItem&);

		DataItem _dataItem;
};

class PreferencesDialog : public Gtk::Dialog 
{
	public:

		PreferencesDialog();

		int LaunchDialog();

	private:
		
		/*
		 *  Private Methods
		 */

		void _FillDialogValues();
		
		/*
		 *  Widgets in dialog
		 */
		
		Gtk::CheckButton _useShortTimeFormatButton;

		Gtk::CheckButton _useCustomDateTimeButton;
		Gtk::Label _customDateTimeLabel;
		Gtk::Entry _customDateTimeFormatEntry;

		Gtk::CheckButton _autoSaveButton;

		// these here define 'default' values for new items
		// they can later be changed on 'item settings'
		Gtk::CheckButton _useBellButton;
		Gtk::Entry _bellCommandEntry;

		Gtk::HBox _bellPeriodBox;
		Gtk::SpinButton _bellPeriodButton;
		Gtk::Label _bellPeriodLabel;

		/*
		 *  Other private members
		 */
		
};

#endif /* end DIALOGS_H */