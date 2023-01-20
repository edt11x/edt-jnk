
#include <string>
#include <iostream.h>

class base 
{
public:
    base(int ia, int ib);
    static void printme();

private:
    int a;
    int b;
    static int c;
};

class derived : public base
{
public:
    derived(int ia, int ib);
    static void printme();

private:
    derived();
};

base::base(int ia, int ib) : a(ia), b(ib)
{
    c = 100;
    base::printme();
};

int base::c = 99;

derived::derived(int ia, int ib) : base(ia, ib)
{
    c = 1;
};

void base::printme()
{
    cout << "I am base\n";
}

void derived::printme()
{
    cout << "I am derived\n";
}

main()
{
    const derived foo(3, 2);
    foo.printme();
    const base & foo2 = (const base& ) foo;
}

