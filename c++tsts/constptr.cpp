
#include <iostream>
#include <string>

using std::string;
using std::cout;

int foo[] = {0, 1, 2, 3, 4, 5};

main()
{
    int * pFoo = &foo[0];
    const int * pFoo2 = &foo[0];

    pFoo2 = pFoo + 4;

    cout << "Hi\n";
    cout << *pFoo  << "\n";
    cout << *pFoo2 << "\n";
    cout << "End\n";
}
