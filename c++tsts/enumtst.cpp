
#include <string>
#include <iostream.h>

using std::string;

class MyFooClass {

public:
    enum fooRange {
        eNull,
        eLow,
        eMid,
        eHigh
    };

    void setName(string &name)
    {
        myFooName = name;
    }

    string & getName()
    {
        return myFooName;
    }

protected:
    string myFooName;
};

int main()
{
    MyFooClass m;
    string s1 = "foo";

    cout << "hi\n";
    m.setName(s1);
    cout << m.getName();
    cout << "\n";
    cout << MyFooClass::eNull;
    cout << "\n";
    cout << MyFooClass::eLow;
    cout << "\n";
    cout << MyFooClass::eMid;
    cout << "\n";
    cout << MyFooClass::eHigh;
    cout << "\nend\n";
}
