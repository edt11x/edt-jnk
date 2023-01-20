
#include <string>
#include <iostream>

using std::string;
using std::cout;

typedef struct foo {
    int i;
    int k;
} foo;

class MyFooClass {

public:
    static const int somevar = 5;

    static int someothervar;

    // XXX DOES NOT WORK on gcc 3.3 XXX static int somearray[] = {1, 2};

    static foo bar[];

    class SomeClass {
        public:
            int a;
            int b;
            SomeClass() : a(7), b(8)
            {
            };
        } someclass;

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

int MyFooClass::someothervar = 6;

foo MyFooClass::bar[] = {
        {1, 2},
        {3, 4}
    };

int main()
{
    MyFooClass m;
    string s1 = "foo";

    cout << "hi\n";
    m.setName(s1);
    cout << m.getName()    << "\n";
    cout << m.somevar      << "\n";
    cout << m.someothervar << "\n";
    cout << m.someclass.a  << "\n";
    cout << m.someclass.b  << "\n";
    cout << "end\n";
}

