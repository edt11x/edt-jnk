
#include <string>
#include <iostream.h>

using std::string;

int main()
{
    string *s1 = new string("asdf");
    const string &s2 = string("asdf");
    
    cout << "hi\n";
    cout << s1->compare("asdf");
    cout << "\n";
    cout << s1->compare("asndf");
    cout << "\n";
    if (*s1 == "asdf") {
        cout << "compares";
    } else {
        cout << "fails compare";
    }
    cout << "\n";
    cout << s2;
    cout << "\nend.\n";
}
