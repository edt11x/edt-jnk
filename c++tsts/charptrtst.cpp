
#include <iostream>
#include <string>

using std::string;
using std::cout;

main()
{
    char *a = "asdf";
    char b[5] = "qwer";

    cout << a << "\n";
    cout << b << "\n";

    cout << *(a+1) << "\n";
    cout << *(b+1) << "\n";

    cout << a[1] << "\n";
    cout << b[1] << "\n";

    cout << 1[a] << "\n";
    cout << 1[b] << "\n";
}
