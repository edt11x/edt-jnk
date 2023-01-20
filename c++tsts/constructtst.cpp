
#include <string>
#include <iostream>

using std::string;
using std::cout;

class MyFooClass {

    public:
        MyFooClass()
        {
            cout << "MyFooClass constructed.\n";
        };
        virtual ~MyFooClass()
        {
            cout << "MyFooClass destructed.\n";
        }

        void setFooString(const string &name)
        {
            myFooString = name;
        };
        void printFooString()
        {
            cout << "Foo String " << myFooString << "\n";
        };

    protected:
        string myFooString;
};

class MyBarClass : public MyFooClass {
    public:
        MyBarClass()
        {
            cout << "MyBarClass constructed.\n";
        };

        ~MyBarClass()
        {
            cout << "MyBarClass destructed.\n";
        };
};

int main()
{
    cout << "\nBeginning of test.\n\n";
    {
        MyBarClass b;   // b should be constructed.

        b.setFooString("This is a test");
        b.printFooString();
    }
    cout << "\n\nEnd of test.\n";
}
