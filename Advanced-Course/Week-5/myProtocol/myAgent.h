#ifndef _MY_AGENT_
#define _MY_AGENT_

#define NOW Scheduler::instance().clock()

#include <math.h>
#include <random.h>
#include "object.h"
#include <string>

#include <trace.h>
#include <tclcl.h>

#include <address.h>
#include "ip.h"

#include "mobilenode.h"
#include "agent.h"
#include "packet.h"

#include <priqueue.h>
#include <mac.h>
#include <app.h>


struct hdr_myhdr
{
	int nodeID;
	double CurTime;

	static int offset_;
	inline static int& offset() {return offset_;}
	inline static hdr_myhdr* access(const Packet* p) {
		return (hdr_myhdr*) p->access(offset_);
	}
};


class My_Agent : public Agent
{
	public:
		My_Agent();
		~My_Agent();
		int command(int argc, const char*const* argv);
};

#endif

