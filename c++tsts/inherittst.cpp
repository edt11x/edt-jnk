
#include <string>
#include <iostream.h>

class foo1 
{
public:
    foo1(int ia, int ib);
    void printthem();
    static void printme();

private:
    int a;
    int b;
    static int c;
};

class foo2 : public foo1
{
public:
    foo2(int ia, int ib);
    static void printme();

private:
    foo2();
};

foo1::foo1(int ia, int ib) : a(ia), b(ib)
{
    c = 100;
    foo1::printme();
};

int foo1::c = 99;

foo2::foo2(int ia, int ib) : foo1(ia, ib)
{
    c = 1;
};

void foo1::printme()
{
    cout << "I am foo1\n";
}

void foo2::printme()
{
    cout << "I am foo2\n";
}

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
    foo2 foo(3, 2);
    foo.printthem();
}

