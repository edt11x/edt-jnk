
#include <string>
#include <iostream.h>

using std::string;

class MyFooClass {

private:
    MyFooClass()
    {
    }

public:
    static MyFooClass & getThe()
    {
        static MyFooClass theOne;

        return theOne;
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
    string s1 = "foo";

    cout << "hi\n";
    MyFooClass::getThe().setName(s1);
    cout << MyFooClass::getThe().getName();
    cout << "\nend\n";
}
