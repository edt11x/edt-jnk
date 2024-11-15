
#include <iostream>
#include <string>

using std::string;
using std::cout;

class SomeClass {
    public:
        SomeClass()
        {
            i = 1;
            j = 2;
            k = 3;
            f = 4.4;
            s = "A pointer to this string";
        };

        static void someMethod(SomeClass *sc)
        {
            sc->printMe();
        };

        void printMe()
        {
            cout << i << "\n";
            cout << j << "\n";
            cout << k << "\n";
            cout << f << "\n";
            cout << s << "\n";
        };

    private:
        int i;
        int j;
        int k;
        float f;
        char * s;
        double foobar[1000];
        // double foobar[99999999];
};

extern "C" {
    main()
    {
        try {
            SomeClass sc;
            void (*someMethodPointer)(SomeClass *) = NULL;
            sc.printMe();
            SomeClass::someMethod(&sc);
            someMethodPointer = (void (*)(SomeClass *)) &SomeClass::someMethod;
            someMethodPointer(&sc);
            cout << "Size of SomeClass : " << sizeof(SomeClass) << "\n";
        } 
        catch (...) {
            cout << "Bad constructor\n";
        }
    }
};

