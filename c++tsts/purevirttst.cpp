
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

        void setFooString(string &name)
        {
            myFooString = name;
        };

        virtual void fooVirt() = 0;


    protected:
        string myFooString;
};

void MyFooClass::fooVirt()
{
    cout << "Should this be possible?\n";
}

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

        void fooVirt()
        {
            MyFooClass::fooVirt();
            cout << "fooVirt()\n";
        }
};

int main()
{
    MyBarClass b;
    b.fooVirt();
    cout << "hi\n";
}
