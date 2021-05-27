#include "scheduler.h"
#include "random.h"

#include "rtp.h"
#include "trace.h"

#include "object.h"
#include "agent.h"
#include "packet.h"
#include "ip.h"
#include "mac.h"
#include "ll.h"

#include "myAgent.h"

int hdr_myhdr::offset_;


static class My_Agent_Class : public TclClass
{
	public:
		My_Agent_Class() : TclClass("Agent/MyAgent") {}

		TclObject* create(int, const char*const*)
		{
			return (new My_Agent());
		}
} class_myagent;



My_Agent::My_Agent() : Agent(PT_MYHD)
{
	//Packet* p = allocpkt();

	Packet* p = Packet::alloc();
	Agent::initpkt(p);

	hdr_ip *iph = hdr_ip::access(p);
	hdr_cmn *cmh = hdr_cmn::access(p);
	hdr_myhdr *myh = hdr_myhdr::access(p);

	myh->CurTime = NOW;
	myh->nodeID = 1;

	cmh->ptype() = PT_MYHD;

	printf("MyAgent Allocate Packet with Type:%s\n", packet_info.name(PT_MYHD));

	Packet::free(p);
}


My_Agent::~My_Agent()
{
}


int My_Agent::command(int argc, const char*const* argv)
{

	if (argc == 2)
	{
		if(strcmp(argv[1], "createpacket") == 0)
			{


			}
	}

  // If the command hasn't been processed by OracleAgent::command, call the command() function for the base class
	return (Agent::command(argc, argv));
}
