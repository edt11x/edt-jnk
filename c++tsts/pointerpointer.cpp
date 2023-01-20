
#include <iostream>
#include <string>

using std::cout;
using std::string;

class FooClass 
{
public:
    void setString(char * s)
    {
        _s = s;
    };

    void getString(char ** const s)
    {
        *s = _s;
    };

private:
    char * _s;
};


main()
{
    FooClass a;
    char *p;

    a.setString("Happy, happy, happy");
    a.getString(&p);

    cout << "Hi\n";
    cout << p << "\n";
    cout << "End\n";
}


