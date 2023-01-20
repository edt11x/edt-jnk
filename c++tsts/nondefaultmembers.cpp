
#include <iostream>
#include <string>

using std::cout;
using std::string;

class FooClass
{
protected:

public:
    FooClass(int a);
    FooClass()
    {
        _a = 99;
    };
    void printMe( void )
    {
        cout << _a << "\n";
    };

private:
    int _a;
};

FooClass::FooClass( int a )
{
    _a = a;
};

class BarClass 
{
public:
    BarClass() : fooClass(11)
    {
    };
    FooClass fooClass;
    void printMe( void )
    {
        fooClass.printMe();
    };
};

main()
{
    BarClass b;

    cout << "Hi\n";
    b.printMe();
    cout << "End\n";
}


