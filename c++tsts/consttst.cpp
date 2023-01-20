
#include <string>
#include <iostream>

using std::string;
using std::cout;

class MyFXString {

public:
    MyFXString(const int strSize);
    inline const char * const * const getFooString()
    {
        return &_fooString;
    }

private:
    const int _iStrSize;
    char * _szBuffer;  /**< the plus one is for the NULL character */
    static const char * const _fooString;

};

const char * const MyFXString::_fooString = "asdf";

MyFXString::MyFXString(const int strSize) : _iStrSize(strSize), _szBuffer(new char[_iStrSize])
{
}


int main()
{
    MyFXString a(20);

    cout << "hi\n";
    cout << *a.getFooString();
    cout << "\nend\n";
}

