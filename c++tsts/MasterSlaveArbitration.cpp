
#include <iostream>
#include <string>
#include <assert.h>

using std::iostream;
using std::string;

#define TESTING 1

// for no debug, #define EDTDBG with no arguments.
// The result is an express like ("%s\n", somestring), which will quietly evaluate and go away.
#define EDTDBG printf

/* Maximum number of LRUs */
#define MAX_NUM_LRUS      10

/* Maximum time we will wait for a MSA heartbeat on startup */
#define MAX_STARTUP_WAIT  60

/* Minimum time we should see a heartbeat message from MSA */
#define MIN_MSA_HB_RECV  2

/* How often we should send a heartbeat message if we are a Master */
#define MSA_HB_SEND      1

/* Last set of Master heartbeat messages we have seen */
/* This is primarily for debugging */
#define ALIVE_TIME_ARRAY 5

typedef long   int32;

typedef long   MSALru;
typedef time_t MSATime;
typdef  long   MSAStatus;

/* 
 * We are sort of using a detect dead algorithm, so we do not need to 
 * keep how many are alive.
 */

class MSAHeartbeat 
{
public:
    MSALru    msalruID;
    MSATime   msatSendTime;
    MSAStatus msasStatus
};

class MasterSlaveArbitration
{
private:
    int32      i4Length;                      // count of LRUs participating in MSA
    MSALru     msalruLRUArry[MAX_NUM_LRUS]; // array of LRUs participating in MSA
    int32      i4Index;                       // index pointing to current expected Master for MSA

    void clearMSAArray()
    {
        EDTDBG("clearMSAArray()\n");
        i4Length = 0;
        for (int i = 0; i < MAX_NUM_LRUS; i++)
        {
            msalruLRUArray[i] = NULL;
        }
        i4Index  = 0;
    };

    void loadMSAConfig()
    {
        EDTDBG("loadMSAConfig()\n");
        clearMSAArray();
        // XXX XXX XXX TMP Hardcoded Config, Replace with Real Version
        msalruLRUArray[0] = 1;
        msalruLRUArray[1] = 2;
        i4Length = 2;
        // XXX XXX XXX TMP Hardcoded Config, Replace with Real Version
        assert((i4Length > 0) && (i4Length < MAX_NUM_LRUS));
    };

    bool checkForMessage()  // wrapper for checking for messages
    {
        EDTDBG("checkForMessage()\n");
        // XXX XXX XXX Need a real check for message routine
        return false;
    };

    bool getMessage(MSALru & l, MSATime & t, MSAStatus & s)
    {
        EDTDBG("getMessage()\n");
        assert((l >= 0) && (l < MAX_NUM_LRUS));
        assert((i4Length > 0) && (i4Length < MAX_NUM_LRUS));
    };

public:
    MasterSlaveArbitration()
    {
        EDTDBG("MasterSlaveArbitration::MasterSlaveArbitration()\n");
        clearMSAArray();
    };
    ~MasterSlaveArbitration()
    {
        EDTDBG("MasterSlaveArbitration::~MasterSlaveArbitration()\n");
    };
    void initialize()
    {
        EDTDBG("initialize()\n");
        loadMSAConfig();
    };
    void dumpStatus()
    {
        EDTDBG("dumpStatus()\n");
        EDTDBG("LRU Array\n");
        for (int i = 0 ; i < i4Length; i++)
        {
            EDTDBG(" LRU : %d\n", msalruLRUArray[i]);
        }
        EDTDBG("done with dumpStatus()\n");
    };
    void processMSA()
    {
        EDTDBG("processFLA()\n");
        // we should receive heartbeat messages
        while (checkForMessage())
        {
            // Loop on the number of messages available
            if (getMessage(l, t, s))
            {
            }
        }
    };
};


main()
{
    MasterSlaveArbitration msa;

    msa.initialize();
    msa.dumpStatus();
    exit(0);
}

