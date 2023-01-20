
#include <string>
#include <iostream.h>

using std::string;

class MyFooClass {

public:

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
    cout << "\nend\n";
}
