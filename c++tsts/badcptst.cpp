
#include <string>
#include <iostream>

using std::string;
using std::cout;

class MyFooClass {

    public:
        MyFooClass()
        {
            cout << "MyFooClass constructed.\n";
            count++;
        };
        ~MyFooClass()
        {
            cout << "MyFooClass destructed.\n";
            count--;
        };
        void setFooString(string &name)
        {
            myFooString = name;
        };
        void myFooPrint()
        {
            cout << myFooString << "\n";
            cout << "Count of MyFooClass objects : " << count << "\n";
        };

    protected:
        string myFooString;
        static int count;
};

int MyFooClass::count = 0;

int main()
{
    MyFooClass *pf = new MyFooClass;
    string foo = "asdf";
    pf->setFooString(foo);
    pf->myFooPrint();

    char buf[1000];
    char *s = &buf[0];
    std::memcpy(s, pf, sizeof(MyFooClass));
    MyFooClass *pf2 = (MyFooClass *) s;

    string bar = "qwer";
    pf2->setFooString(bar);
    pf2->myFooPrint();

    cout << "end\n";
}
