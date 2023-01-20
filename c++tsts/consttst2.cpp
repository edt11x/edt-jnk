
#include <iostream>
#include <string>

using std::string;
using std::cout;

main()
{
    const int *pVar1;
    int *pVar2 = NULL;
    pVar1 = pVar2;
    *pVar2 = 5;
}

