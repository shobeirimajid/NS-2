
#ifndef _MY_APPLICATION_
#define _MY_APPLICATION_

#include <fstream>
#include <iostream>
#include <list>

#include <string.h>
#include <scheduler.h>
#include <tclcl.h>

#include <agent.h>
#include <node.h>
#include <mobilenode.h>

using namespace std;


/**
 * MyApplicat Base Class.
 */
class MyApplication : public Application
{
	public:

		MyApplication(int NodeID);
		~MyApplication();
		int command(int, const char* const*); 	// Interface to running NS2 commands from TCL level

		int nodeID;
		void newRound();
};

#endif