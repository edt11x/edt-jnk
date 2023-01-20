
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
    MyBarClass b;
    cout << "hi\n";
}
