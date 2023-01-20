
#include <string>
#include <iostream.h>

class foo1 
{
public:
    foo1(int ia, int ib, int ic);
    void printthem();

private:
    int a;
    int b;
    int & c;
};

foo1::foo1(int ia, int ib, int ic) : a(ia), b(ib), c(ic)
{
};

void foo1::printthem()
{
    cout << "hi\n";
    cout << a;
    cout << "\n";
    cout << b;
    cout << "\n";
    cout << c;
    cout << "\nend\n";
};

main()
{
    foo1 foo(1, 2, 3);
    foo.printthem();
}

