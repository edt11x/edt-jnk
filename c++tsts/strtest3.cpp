
#include <string>
#include <iostream.h>

using std::string;

class Event
{
public:
    int foo1;
    int foo2;

    /// Constructor
    Event();

    /// Destructor
    ~Event();
};

Event::Event()
{
}

Event::~Event()
{
}

class Message
{
public:
    
    /// Constructor
    Message(Event &e);

    /// Destructor
    ~Message();

    Event & getEvent();

    const string& strRetExper();


protected:
    Event & itsEvent;
    string itsString;
};

Message::Message(Event &e)
    : itsEvent(e)
{
}

Message::~Message()
{
}

Event & Message::getEvent()
{
    return itsEvent;
}

const string& Message::strRetExper()
{
    // String return experiment
    itsString = "asdf";
    return itsString;
}

main()
{
    Event e;
    e.foo1 = 23;
    e.foo2 = 24;
    Message m(e);

    Event & e2 = m.getEvent();

    cout << "hi\n";
    cout << e2.foo1;
    cout << "\n";
    cout << e2.foo2;
    cout << "\n";

    cout << "String Return Experiment\n";
    cout << m.strRetExper();
    cout << "\n";

    cout << "end\n";
}

