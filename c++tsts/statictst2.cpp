
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

    const string & getName() const
    {
        return myFooName;
    }

    const int & getInt() const
    {
        return myFooInt;
    }

protected:
    string myFooName;
    int myFooInt;
};

int main()
{
    MyFooClass m;
    string s1 = "foo";
    string s2 = "bar";

    cout << "hi\n";
    m.getThe().setName(s1);

    cout << m.getThe().getName();   // <<-- Returns "foo"
    cout << "\n";
    cout << m.getThe().getInt();    // <<-- Returns 0
    cout << "\nend\n";
}

