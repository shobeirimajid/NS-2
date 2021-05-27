
#include "myApplication.h"
#include <tools/random.h>


/**
 * Shadow object.
 */
static class myApplicationClass:public TclClass {
	public:
		myApplicationClass():TclClass("Application/MyApplication"){}

		/**
		 * Create a TCL Object (parameters starts in 4)
		 * Each call in tcl level have at least 4 parameter. param0 to param3.
		 * and argc keep the number of parameters.
		 */
		TclObject* create(int argc, const char * const * argv) {

			if(argc!=5) {
				printf("Invalid syntax! \n\t\t\t Use this syntax: MyApplication <NodeID>\n");
				exit(-1);
			}
			return (new MyApplication(atoi(argv[4])));
		}
} my_application_class;



/**
 * Constructor.
 */
MyApplication::MyApplication(int NodeID) : Application()
{
	nodeID = NodeID;
	eventHandler_ = new MyEventHandler(this);
}



/**
 * Destructor.
 */
MyApplication::~MyApplication()
{}



/**
 * command() is the Main entry point from TCL call.
 * If the TCL command contains [MyApplication Object] x y z
 * then x y z are passed as "argv" to this command method.
 */
int MyApplication::command(int argc,const char* const* argv)
{

	if(argc == 2)
	{
		if(strcmp("start",argv[1])==0)
		{
			newRound();
			return TCL_OK;
		}
	}
	
	// If the command hasn't been processed by MyApplication::command, call the Application::command() function.
	return Application::command(argc,argv);
}



void MyApplication::newRound()
{
	//Scheduler::instance().schedule(eventHandler_, new MyEvent(&MyApplication::newRound), SleepTime);
}








