
#include <iostream>
#include <string>

using std::string;
using std::cout;

class FooObject
{
public:
    FooObject()
    {
        status = 0;
        statusPtr = &status;
    };
    ~FooObject()
    {
        statusPtr = NULL;
    };
    int * getStatusPtr()
    {
        return statusPtr;
    };
    int status;
    int * statusPtr;
};

class BarObject
{
public:
    FooObject * getFooObjPtr()
    {
        return &f;
    };
    FooObject f;
};

main()
{
    FooObject *f;
    {
        BarObject b;
        f = b.getFooObjPtr();
    }
    if (f->getStatusPtr() != NULL)
    {
        cout << "Do something\n";
    }
}


