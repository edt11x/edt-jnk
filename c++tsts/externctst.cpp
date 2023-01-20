
#include <iostream>
#include <string>

using std::cout;
using std::string;

class MyFooClass {

public:
    static void RunController( void )
    {
        std::cout << "RunController()\n";
    };

};

extern "C" void RunController()
{
    MyFooClass::RunController();
}

main()
{
    MyFooClass a;

    RunController();
    a.RunController();
    MyFooClass::RunController();
}
