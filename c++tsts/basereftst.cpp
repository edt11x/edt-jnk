
#include <iostream>
#include <string>

using std::cout;
using std::string;

const int foo (2), bar(3);


class BaseClass 
{
public:
    void printMe( void )
    {
        cout << "printMe()\n";
        cout << foo << "\n";
    };
};

class DerivedClass : public BaseClass
{
public:
    void printMe2( void )
    {
        cout << "printMe2()\n";
    };
};

class SomeClass {
public:
    void somePrintMethod(BaseClass & bc )
    {
        BaseClass *pbc = &bc;
        pbc->printMe();
    };
};



main()
{
    DerivedClass dc;
    SomeClass    sc;

    sc.somePrintMethod(dc);
}



