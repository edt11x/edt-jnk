
#include <string>
#include <iostream>

using std::string;
using std::cout;

class BaseClass {

    public:
        virtual void send(const char * s) = 0;
        virtual void send(const char * s, const char * t) = 0;
};

class DerivedClass : BaseClass {

    public:
        void send(const char *s)
        {
            string s1 = s;

            cout << s1 << "\n";
        }

        void send(const char *s, const char *t)
        {
            string s1 = s;
            string t1 = t;

            cout << s1 << t1 << "\n";
        }
};


int main()
{
    DerivedClass d;

    cout << "hi\n";
    d.send("foo");
    // d.send("foo", "bar");
    cout << "end\n";
    return(0);
}


