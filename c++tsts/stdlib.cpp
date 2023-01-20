#include <string>
#include <iostream>
#include <sstream>

int main()
{
std::string Str;
std::stringstream ss("hello");
std::getline(ss,Str);
std::cout << Str;

return 0;
}
