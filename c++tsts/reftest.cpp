
#include <iostream.h>

int asdf = 2;

int& f()
{
   return asdf;
}

main()
{
    cout << "hi\n";
    cout << f();
    cout << "\nend.\n";
}
