
#include <string>
#include <iostream>

using std::string;
using std::cout;

#include "StdIncl.h"
#include "FXString20.h"

class MyFooClass {

public:
    MyFooClass(FXString20 z);

protected:
    FXString20 & _z;
};

MyFooClass::MyFooClass(FXString20 z) : _z(z)
{
}

int
main()
{
    FXString20 a;

    MyFooClass b(a);
    MyFooClass c((FXString20) "This is a test");

    cout << "hi\n";
    return(0);
}
