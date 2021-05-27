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


static class My_Agent_Class : public TclClass
{
	public:
		My_Agent_Class() : TclClass("Agent/MyAgent") {}

		TclObject* create(int, const char*const*)
		{
			return (new My_Agent());
		}
} class_myagent;



My_Agent::My_Agent() : Agent(PT_TCP)
{
	// 1- Variable Binding
	bind("packetSize_", &pkt_size_);
}


My_Agent::~My_Agent()
{}


int My_Agent::command(int argc, const char*const* argv)
{

	if (argc == 2)
	{
		if (strcmp(argv[1], "start-WL-brdcast") == 0)
		{
			Packet* pkt = allocpkt();
			hdr_ip* iph = HDR_IP(pkt);
			iph->daddr() = IP_BROADCAST;
			iph->dport() = iph->sport();
			send(pkt, (Handler*) 0);
			return (TCL_OK);
		}

		if (strcmp(argv[1], "packet-Size") == 0)
		{
			// 1- Variable Binding
			//printf("%d\n", pkt_size_);


			// 2- Running C++ statements from OTcl level
			//printf("%d\n", pkt_size_);


			// 3- Runnig OTcl Statements from C++ level
			//Tcl& tcl = Tcl::instance();
			//tcl.eval("puts [$agent(1) set packetSize_]");


			// 4- Passing Result from C++ to OTcl level
			Tcl& tcl = Tcl::instance();
			tcl.resultf("%d",pkt_size_);

			return (TCL_OK);
		}

	}
  
	// If the command hasn't been processed by My_Agent::command, call the command() function for the base class
	return (Agent::command(argc, argv));
}