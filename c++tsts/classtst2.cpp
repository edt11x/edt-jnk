
#include <string>
#include <iostream.h>

class foo1 
{
public:
    foo1(int ia, int ib);
    void printthem();

private:
    int a;
    int b;
};

class foo2 : public foo1
{
public:
    foo2(int ia, int ib);

private:
    foo2();
};

foo1::foo1(int ia, int ib) : a(ia), b(ib)
{
};

foo2::foo2(int ia, int ib) : foo1(ia, ib)
{
};

void foo1::printthem()
{
    cout << "hi\n";
    cout << a;
    cout << "\n";
    cout << b;
    cout << "\nend\n";
};

main()
{
    foo2 foo(2, 3);
    foo.printthem();
}

