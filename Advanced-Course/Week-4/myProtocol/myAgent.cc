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
}


My_Agent::~My_Agent()
{
}


int My_Agent::command(int argc, const char*const* argv)
{
  // If the command hasn't been processed by OracleAgent::command, call the command() function for the base class
	return (Agent::command(argc, argv));
}
