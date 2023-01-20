
#include <iostream>
#include <string>
#include <assert.h>

using std::cout;
using std::string;

#define TESTING 1

// for no debug, #define EDTDBG with no arguments.
// The result is an express like ("%s\n", somestring), which will quietly evaluate and go away.
#define EDTDBG printf

#define MAX_NUM_FEATURES 100

#define MAX_NUM_LRUS     10

#define MIN_ALIVE_TIME   20

#define MIN_ALIVE_SEND   5

#define ALIVE_TIME_ARRAY 5

typedef long int32;

typedef long Feature;
typedef long LockNeed;
typedef long LockStatus;
typedef long LockMessage;
typedef long LockLRU;

typedef time_t LockTime;

class FeatureLockAdmin 
{
private:
    LockNeed   alnMatrix[MAX_NUM_FEATURES][MAX_NUM_FEATURES]; // could be sparse array for efficiency
    LockStatus alsLockPending[MAX_NUM_FEATURES];              // status of current locks
    int32      ai4LockCount[MAX_NUM_FEATURES];                // count of current locks
    int32      ai4MessagesRead[MAX_NUM_FEATURES];             // lock messages read from other LRUs
    int32      i4Length;                                      // length of the feature matrix read from config
    int32      i4NumOfAliveLRUs;                              // current number of alive LRUs
    LockTime   altAliveMessages[MAX_NUM_LRUS][ALIVE_TIME_ARRAY];  // array of our alive messages from LRUs
    LockTime   ltLastAliveSent;                               // last time we sent an alive message

public:
    static const LockNeed    NO_NEED           = 0;
    static const LockNeed    NEED              = !0;

    static const LockStatus  LOCK_OPEN         = 0;
    static const LockStatus  LOCK_PENDING      = 1;
    static const LockStatus  LOCK_LOCKED       = 2;

    static const LockMessage LOCK_MSG_NONE     = 0;
    static const LockMessage LOCK_MSG_INQUIRY  = 1;
    static const LockMessage LOCK_MSG_RESPONSE = 2;
    static const LockMessage LOCK_MSG_ALIVE    = 3;

    FeatureLockAdmin() : i4Length(MAX_NUM_FEATURES), i4NumOfAliveLRUs(1), ltLastAliveSent(0)
    {
        EDTDBG("FeatureLockAdmin::FeatureLockAdmin() -- constructor\n");
        clearFeatureMatrix();
        clearAliveMessages();
        loadFeatureMatrix();
    };

    ~FeatureLockAdmin()
    {
        i4Length         = 0;    // no features
        i4NumOfAliveLRUs = 0;    // no alive LRUs
        ltLastAliveSent  = 0;
        EDTDBG("FeatureLockAdmin::~FeatureLockAdmin() -- destructor\n");
        clearFeatureMatrix();
        clearAliveMessages();
        EDTDBG("We are done.\n");
    };

    LockStatus doIHaveTheLock(Feature f)
    {
        EDTDBG("doIHaveTheLock(%d) will return %s\n", f, returnLockStatusString(f));
        assert((i4Length > 0) && (i4Length < MAX_NUM_FEATURES));
        if ((f >= 0) && (f < i4Length))
        {
            return alsLockPending[f];            // just return the lock status
        }
        else
        {
            return LOCK_OPEN;                   // Bad lock number, in general should not happen
        }
    };

    LockStatus askForFeature(Feature f)
    {
        EDTDBG("askForFeature(%d)\n", f);
        assert((i4Length > 0) && (i4Length < MAX_NUM_FEATURES));
        if ((f >= 0) && (f < i4Length) && (alsLockPending[f] == LOCK_OPEN))  // Check if the feature is open
        {
            alsLockPending[f] = LOCK_PENDING;    // it is must be open, mark it as pending
            sendLockInquiry(f);                 // ask the other LRUs for their status for this feature.
        }
        return doIHaveTheLock(f);               // return the lock status
    };

    void releaseTheFeature(Feature f)
    {
        EDTDBG("releaseTheFeature(%d)\n", f);
        assert((i4Length > 0) && (i4Length < MAX_NUM_FEATURES));
        assert(f        < MAX_NUM_FEATURES);
        assert(alnMatrix[f][f] == NEED);     // we must need ourselves or the config is bad and we are done
        if (alsLockPending[f] == LOCK_OPEN)
        {
            return;                         // lock already open, nothing to do
        }
        else if (alsLockPending[f] == LOCK_PENDING)
        {
            alsLockPending[f] = LOCK_OPEN;   // clear the pending information
            ai4MessagesRead[f] = 0;
        }
        else if (alsLockPending[f] == LOCK_LOCKED) // need to clean up all three arrays
        {
            alsLockPending[f] = LOCK_OPEN;
            ai4MessagesRead[f] = 0;
            for (int32 j = 0; j < i4Length; j++)
            {
                if (alnMatrix[f][j] == NEED)
                {
                    ai4LockCount[j]--;
                }
            }
        }
        else
        {
            assert(0);                      // Lock Pending table is corrupted. Should not happen.
        }
    };

    void processFLA()   // should be called from someones processThisApp()
    {
        LockLRU     l;
        LockMessage m;
        Feature     f;
        LockStatus  s;

        EDTDBG("processFLA();\n");
        // we should receive inquires, responses and alive messages
        while (checkForMessage())
        {
            // Loop on the number of messages available
            if (getMessage(l, m, f, s))
            {
                if (m == LOCK_MSG_INQUIRY)
                {
                    // check the lock counts by looking up dependent features in matrix
                    if (areThereAnyDependentsLocked(f))
                    {
                        sendMessageResponse(f, LOCK_LOCKED);
                    }
                    else
                    {
                        sendMessageResponse(f, LOCK_OPEN);
                    }
                }
                else if (m == LOCK_MSG_RESPONSE) // if it is a response message
                {
                    // we did an inquiry and this is a response from another LRU.
                    if ((alsLockPending[f] == LOCK_PENDING)  // if our lock for that feature is pending
                        && (s == LOCK_OPEN))                // and the remote status of that lock is open
                    {
                        // increment the message recd array for this feature
                        ai4MessagesRead[f]++;
                        // if we reached the correct number of messages, lock this feature
                        if (i4NumOfAliveLRUs == ai4MessagesRead[f])
                        {
                            // One question is, should we do this i4NumOfAliveLRU check outside the
                            // message loop. The reason is that we may discover a drop in the number
                            // of alive LRUs and then a pending could change to locked. I think not.
                            // We lock what we can, the rest timeout.

                            // lock this feature
                            lockTheFeature(f);
                        }
                    }
                    else if ((alsLockPending[f] == LOCK_PENDING) // if our lock for that features is pending
                        && (s != LOCK_OPEN))                    // and the remote status is not open
                    {
                        alsLockPending[f]  = LOCK_OPEN;
                        ai4MessagesRead[f] = 0;
                    }
                    else // if (alsLockPending[f] != LOCK_PENDING) -- if our lock is not in pending mode
                    {
                        // that is weird, what does this mean?
                        // we will ignore this message.
                        // if we get a good response and our LOCK is open, what caused this?
                        // if we get a good response and our LOCK is locked, what caused this?
                        // probably should generate an error.
                        EDTDBG("We have a response and our lock is not pending.\n");
                        EDTDBG("alsLockPending[%d] : %d\n", f, alsLockPending[f]);
                        EDTDBG("Message : %d\n", m);
                        EDTDBG("Feature : %d\n", f);
                        EDTDBG("Status  : %d\n", s);
                    }
                }
                else if (m == LOCK_MSG_ALIVE)
                {
                    // someone is alive, we need to count them, first shuffle the array
                    for (int32 i = ALIVE_TIME_ARRAY - 1; i > 0; i--)
                    {
                        altAliveMessages[l][i] = altAliveMessages[l][i-1];
                    }
                    altAliveMessages[l][0] = getTime();
                    // compute whether any of the LRUs are dead or new
                    countAliveMessages();
                }
            }
        }
        // is it time to send our alive inquiries? 
        // send ourselves an alive message, so we always process the timeouts.
        if (compareTime(getTime(), ltLastAliveSent + MIN_ALIVE_SEND) > 0)
        {
            sendAliveMessage();
            countAliveMessages();
        }
    };

    void dumpStatus()
    {
        EDTDBG("dumpStatus()\n\n");
        EDTDBG("Lock Matrix\n");
        assert((i4Length > 0) && (i4Length < MAX_NUM_FEATURES));
        for (int32 i = 0; i < i4Length; i++)
        {
            for (int32 j = 0; j < i4Length; j++)
            {
                EDTDBG("%s ", (alnMatrix[i][j] == NEED) ? "N" : "-");
            }
            EDTDBG("\n");
        }

        EDTDBG("\nLock Pending Table\n");
        for (int32 i = 0; i < i4Length; i++)
        {
            EDTDBG("%s ", returnLockStatusString(i));
        }

        EDTDBG("\nLock Count Table\n");
        for (int32 i = 0; i < i4Length; i++)
        {
            EDTDBG("%d ", ai4LockCount[i]);
        }

        EDTDBG("\nMessages Read Table\n");
        for (int32 i = 0; i < i4Length; i++)
        {
            EDTDBG("%d ", ai4MessagesRead[i]);
        }
        EDTDBG("\n\n");
    };

private:
    void clearFeatureMatrix()
    {
        EDTDBG("clearFeatureMatrix();\n");
        for (int32 i = 0; i < MAX_NUM_FEATURES; i++)
        {
            for (int32 j = 0; j < MAX_NUM_FEATURES; j++)
            {
                alnMatrix[i][j] = NO_NEED;
            }
            alsLockPending [i] = LOCK_OPEN;
            ai4LockCount   [i] = 0;
            ai4MessagesRead[i] = 0;
            i4Length         = MAX_NUM_FEATURES;
        }
    };

    void loadFeatureMatrix()
    {
        EDTDBG("loadFeatureMatrix()\n");

        // XXX XXX XXX XXX XXX XXX Dummy Load Feature will need to be implemented in the real environment XXX XXX XXX XXX
        // XXX XXX XXX XXX XXX XXX Dummy Load Feature will need to be implemented in the real environment XXX XXX XXX XXX
        // XXX XXX XXX XXX XXX XXX Dummy Load Feature will need to be implemented in the real environment XXX XXX XXX XXX
        alnMatrix[0][0] = NEED;    alnMatrix[0][1] = NO_NEED; alnMatrix[0][2] = NEED;
        alnMatrix[1][0] = NO_NEED; alnMatrix[1][1] = NEED;    alnMatrix[1][2] = NEED;
        alnMatrix[2][0] = NO_NEED; alnMatrix[2][1] = NO_NEED; alnMatrix[2][2] = NEED;
        // XXX XXX XXX XXX XXX XXX Dummy Load Feature will need to be implemented in the real environment XXX XXX XXX XXX
        // XXX XXX XXX XXX XXX XXX Dummy Load Feature will need to be implemented in the real environment XXX XXX XXX XXX
        // XXX XXX XXX XXX XXX XXX Dummy Load Feature will need to be implemented in the real environment XXX XXX XXX XXX

        i4Length = 3;
        assert((i4Length > 0) && (i4Length < MAX_NUM_FEATURES));
    };

    void clearAliveMessages()
    {
        for (int32 i = 0; i < MAX_NUM_LRUS; i++) 
        {
            for (int32 j = 0; j < ALIVE_TIME_ARRAY; j++)
            {
                altAliveMessages[i][j] = (LockTime) 0;
            }
        }
    };

    void countAliveMessages()
    {
        EDTDBG("countAliveMessages()\n");
        int32 i4NumAlive = 0;
        // for each possible LRU we need to look at the last time a message was received
        // and if it was recent enough than the LRU is considered alive.
        for (int32 i = 0; i < MAX_NUM_LRUS; i++)
        {
            i4NumAlive = 0;
            for (int32 j = 0; j < ALIVE_TIME_ARRAY; j++)
            {
                if (compareTime(getTime(), altAliveMessages[i][j] + MIN_ALIVE_TIME) < 0)
                {
                    i4NumAlive++;
                    break;
                }
            }
        }
        i4NumOfAliveLRUs = i4NumAlive;
        EDTDBG("countAliveMessages() -- number of alive LRUs -- %d\n", i4NumOfAliveLRUs);
    };

    void lockTheFeature(Feature f)
    {
        EDTDBG("lockTheFeature(%d)\n", f);
        // increment the lock count array for the given feature
        assert((i4Length > 0) && (i4Length < MAX_NUM_FEATURES));
        assert(f        < MAX_NUM_FEATURES);
        assert(alnMatrix[f][f] == NEED);     // we must need ourselves or the config is bad and we are done
        for (int32 j = 0; j < i4Length; j++)
        {
            if (alnMatrix[f][j] == NEED)
            {
                ai4LockCount[j]++;           // increment the lock count
            }
        }
        alsLockPending[f] = LOCK_LOCKED;     // change Lock Pending to Lock in the LockPending array
    };

    void releaseTheFeature(Feature f)
    {
        EDTDBG("releaseTheFeature(%d)\n", f);
        assert((i4Length > 0) && (i4Length < MAX_NUM_FEATURES));
        assert(f        < MAX_NUM_FEATURES);
        assert(alnMatrix[f][f] == NEED);     // we must need ourselves or the config is bad and we are done
        if (alsLockPending[f] == LOCK_OPEN)
        {
            return;                         // lock already open, nothing to do
        }
        else if (alsLockPending[f] == LOCK_PENDING)
        {
            alsLockPending[f] = LOCK_OPEN;   // clear the pending information
            ai4MessagesRead[f] = 0;
        }
        else if (alsLockPending[f] == LOCK_LOCKED) // need to clean up all three arrays
        {
            alsLockPending[f] = LOCK_OPEN;
            ai4MessagesRead[f] = 0;
            for (int32 j = 0; j < i4Length; j++)
            {
                if (alnMatrix[f][j] == NEED)
                {
                    ai4LockCount[j]--;
                }
            }
        }
        else
        {
            assert(0);                      // Lock Pending table is corrupted. Should not happen.
        }
    };

    bool areThereAnyDependentsLocked(Feature f)
    {
        EDTDBG("areThereAnyDependentsLocked(%d)\n", f);
        // For the given feature do we have any dependents already locked?
        assert((i4Length > 0) && (i4Length < MAX_NUM_FEATURES));
        assert(f        < MAX_NUM_FEATURES);
        assert(alnMatrix[f][f] == NEED);     // we must need ourselves or the config is bad and we are done
        for (int32 j = 0; j < i4Length; j++)
        {
            if (alnMatrix[f][j] == NEED)
            {
                if (ai4LockCount[j])
                {
                    return true;
                }
            }
        }
        return false;
    };

    const char * const returnLockStatusString(Feature f)
    {
        if (f < MAX_NUM_FEATURES)
        {
            return (alsLockPending[f] == LOCK_LOCKED ) ? "L" :
                    ((alsLockPending[f] == LOCK_PENDING) ? "P" : "O");
        }
        else
        {
            return "BAD LOCK NUMBER";
        }
    };

    // XXX XXX XXX XXX XXX XXX Wrapper Functions which will need to be implemented in the real environment XXX XXX XXX XXX
    // XXX XXX XXX XXX XXX XXX Wrapper Functions which will need to be implemented in the real environment XXX XXX XXX XXX
    // XXX XXX XXX XXX XXX XXX Wrapper Functions which will need to be implemented in the real environment XXX XXX XXX XXX

    LockTime getTime()
    {
        // return what time it is now
        time_t tmp;
        tmp = time(NULL);
        return (LockTime) tmp;
    };

    int compareTime(LockTime thisTime, LockTime thatTime)
    {
        if (thisTime < thatTime)
        {
            return -1;
        }
        if (thisTime == thatTime)
        {
            return 0;
        }
        if (thisTime > thatTime)
        {
            return 1;
        }
    };

    void sendLockInquiry(Feature f)
    {
        EDTDBG("sendLockInquiry()\n");
    };

    bool checkForMessage() // a wrapper for checking for messages
    {
        return false;
    };

    bool getMessage(LockLRU &l, LockMessage &m, Feature &f, LockStatus &s) // a wrapper for getting messages
    {
        assert((l >= 0) && (l < MAX_NUM_LRUS));
        assert((i4Length > 0) && (i4Length < MAX_NUM_FEATURES));
        assert(alnMatrix[f][f] == NEED);     // we must need ourselves or the config is bad and we are done

        l = 0;
        m = LOCK_MSG_NONE;
        f = 0;
        s = LOCK_OPEN;

        // get the actual message here XXX XXX XXX XXX.

        // check what we are returning for sanity
        if (((l >= 0) && (l < MAX_NUM_LRUS))                                      // if the LRU is in a valid range
            && ((m == LOCK_MSG_INQUIRY) || (m == LOCK_MSG_RESPONSE) || (m == LOCK_MSG_ALIVE)) // check for messages we recognize
            && ((f >= 0) && (f < i4Length))                                       // and the feature is within range
            && ((s == LOCK_OPEN) || (s == LOCK_PENDING)  || (s == LOCK_LOCKED)))  // and the status is valid
        {
            return true;
        }
        else
        {
            return false;
        }
    };

    void sendMessageResponse(Feature f, LockStatus l)
    {
        EDTDBG("sendMessageResponse(%d, %d)\n", f, l);
        // implement actual send message here XXX XXX XXX XXX.
    }

    void sendAliveMessage()
    {
        EDTDBG("sendAliveMessage()\n");
    };
    // XXX XXX XXX XXX XXX XXX Wrapper Functions which will need to be implemented in the real environment XXX XXX XXX XXX
    // XXX XXX XXX XXX XXX XXX Wrapper Functions which will need to be implemented in the real environment XXX XXX XXX XXX
    // XXX XXX XXX XXX XXX XXX Wrapper Functions which will need to be implemented in the real environment XXX XXX XXX XXX

};

#ifdef TESTING
main()
{
FeatureLockAdmin fla;

    fla.dumpStatus();
    fla.processFLA(); // should be nothing to do
    fla.askForFeature(1);
    fla.dumpStatus();
    fla.doIHaveTheLock(1);
    fla.dumpStatus();
    fla.askForFeature(1);    // I ask again, I should still have the same info.
    fla.dumpStatus();
    sleep(6);
    fla.processFLA();
}
#endif /* #ifdef TESTING */

