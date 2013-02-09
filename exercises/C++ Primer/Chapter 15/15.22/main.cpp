// Ex 15.22: adding Disc_item to hierarchy

#include <iostream>
#include <string>

// set default values that are used in all constructors
const double kDiscount = 0.2;
const double kPrice = 10;
const std::string kBook = "1-1-1111";
const std::size_t kQuantity = 5;

class Item_base 
{
	public:

		Item_base(std::string i = kBook, double p = kPrice): price(p), isbn(i) { }

		// copy constructor
		Item_base(const Item_base &i)  { price = i.price; isbn = i.isbn; std::cout << "Item_base(const &Item_base)" << std::endl; }
		// assign operator
		Item_base& operator=(const Item_base &i) { price = i.price; isbn = i.isbn; std::cout << "Item_base::operator=" << std::endl; }

		virtual double net_price(std::size_t n) { return n * price; }
		virtual ~Item_base() { std::cout << "Item_base destructor" << std::endl; };

	protected:

		double price;
		std::string isbn;
};

class Disc_item : public Item_base
{
	public:

		Disc_item(std::string book = kBook, double p = kPrice, double disc = kDiscount, std::size_t qnt = kQuantity): 
			Item_base(book, p), discount(disc), min_qnt(qnt) {}

		// copy constructor
		Disc_item(const Disc_item &i): Item_base(i)  { min_qnt = i.min_qnt; discount = i.discount; std::cout << "Disc_item(const &Disc_item)" << std::endl; }
		// assign operator
		Disc_item& operator=(const Disc_item &i) { Item_base::operator=(i); min_qnt = i.min_qnt; discount = i.discount; std::cout << "Disc_item::operator=" << std::endl; }

	protected:

		std::size_t min_qnt;
		double discount;
		
};

class Bulk_item : public Disc_item 
{
	public:

		Bulk_item(std::string book = kBook, double p = kPrice, double disc = kDiscount, std::size_t qnt = kQuantity): 
			Disc_item(book, p, disc, qnt) {}

		// copy constructor
		Bulk_item(const Bulk_item &i): Disc_item(i)  { std::cout << "Bulk_item(const &Bulk_item)" << std::endl; }
		// assign operator
		Bulk_item& operator=(const Bulk_item &i) { Disc_item::operator=(i); std::cout << "Bulk_item::operator=" << std::endl; }

		double net_price(std::size_t n);
		~Bulk_item() { std::cout << "Bulk_item destructor" << std::endl; }
};

class Limited_discount : public Disc_item
{
	public:

		Limited_discount(std::string book = kBook, double p = kPrice, double disc = kDiscount, std::size_t qnt = kQuantity): 
			Disc_item(book, p, disc, qnt) {}

		// copy constructor
		Limited_discount(const Limited_discount &i): Disc_item(i)  { std::cout << "Limited_discount(const &Limited_discount)" << std::endl; }
		// assign operator
		Limited_discount& operator=(const Limited_discount &i) { Disc_item::operator=(i); std::cout << "Limited_discount::operator=" << std::endl; }

		double net_price(std::size_t n);
		~Limited_discount() { std::cout << "Limited_discount destructor" << std::endl; }

	private:

		
};

// Limited discount gives discount *after* min_qnt
double Bulk_item::net_price(size_t n)
{
	if (n >= min_qnt)
		return n * (1 - discount) * price;
	else
		return n * price;
}

// Limited discount gives discount *up to* min_qnt
double Limited_discount::net_price(size_t n)
{
	if (n <= min_qnt)
		return n * (1 - discount) * price;
	else
		return n * price;
}

int main()
{
	Bulk_item bulk_a;
	Limited_discount limited_a;

	std::cout << "Purchase of 4 items:" << std::endl;
	std::cout << "Limited_disc: " << limited_a.net_price(4) << std::endl;
	std::cout << "Bulk_item: " << bulk_a.net_price(4) << std::endl;

	std::cout << "Purchase of 14 items:" << std::endl;
	std::cout << "Limited_disc: " << limited_a.net_price(14) << std::endl;
	std::cout << "Bulk_item: " << bulk_a.net_price(14) << std::endl;

	return 0;
}