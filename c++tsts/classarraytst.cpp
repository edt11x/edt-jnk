
#include <string>
#include <iostream.h>

using std::string;

class cb
{
public:
    char * const p;

    /// Constructor
    cb(const int siz);

    /// Destructor
    ~cb();
};

cb::cb(const int siz) : p(new char[siz])
{
}

cb::~cb()
{
}

class theClient
{
public:
    
    /// Constructor
    theClient(const int siz);

    /// Destructor
    ~theClient();
    cb * foo;

};

theClient::theClient(const int siz) : foo(new cb(siz))
{
}

theClient::~theClient()
{
}

main()
{
    cb e(20);
    theClient m(20);

    cout << "hi\n";
    cout << "end\n";
}

