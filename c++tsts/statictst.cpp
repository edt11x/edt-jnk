
#include <string>
#include <iostream>

using std::string;
using std::cout;

class MyFooClass {

public:
    MyFooClass & getThe()
    {
        static MyFooClass foo;

        return foo;
    }

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
    MyFooClass n;
    string s1 = "foo";
    string s2 = "bar";

    cout << "hi\n";
    m.getThe().setName(s1);
    cout << m.getThe().getName();
    cout << "\n";

    n.setName(s2); // <<-- Notice no protection from not using it as a singleton.
    cout << m.getThe().getName();   // <<-- Returns "foo"
    cout << "\n";
    cout << n.getName();            // <<-- Returns "bar"
    cout << "\nend\n";
}

