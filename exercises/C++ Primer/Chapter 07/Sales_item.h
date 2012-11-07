// Sales_item.h

#ifndef SALES_ITEM_H
#define SALES_ITEM_H

#include "Ch7Headers.h"

class Sales_item
{
	// public members
	public:
		// Operations on sales_item objects
		double avg_price() const;
		bool same_isbn(const Sales_item &rhs) const;

		// default constructor
		Sales_item(): units_sold(0), revenue(0.0) { }

	// private members
	private:
		std::string isbn;
		unsigned units_sold;
		double revenue; 
};

#endif