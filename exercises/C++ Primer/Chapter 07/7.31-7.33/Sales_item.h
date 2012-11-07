// 7.31: Sales_item.h

#ifndef SALES_ITEM_H
#define SALES_ITEM_H

#include <sstream>

class Sales_item
{
	// public members
	public:
		// Operations on sales_item objects
		// return average price of an item
		double avg_price() const;
		
		// check if isbn is same than with other Sales_item
		bool same_isbn(const Sales_item &rhs) const;
		
		// print out stats for sales
		std::string read_sales() const;
		
		// add another Sales_item to current
		bool add(Sales_item &other);
		
		// add new sale to current Sales_item 
		// (TODO: default arguments, at least for isbn)
		bool new_sale(const short units, const double income, const std::string isbn);

		// default constructor
		Sales_item(): units_sold(0), revenue(0.0) { }

	// private members
	private:
		std::string to_string(double) const;

		std::string isbn;
		unsigned units_sold;
		double revenue; 
};

#endif