
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

	W_Area = 300;
	H_Area = 300;

	isOnBound = false;
	nodePauseTime = 20;

	nodeSpeed = rng.uniform(1,5);
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

	if(isOnBound)
	{
		nodeDirection = calcDirection();
		nodeSpeed = calcSpeed();
		isOnBound = false;

		nodePauseTime = 20;
		Scheduler::instance().schedule(eventHandler_, new MyEvent(&MyApplication::newRound), nodePauseTime);
	}

	displacement = calcDisplacement();
	movementDuration = calcMovementDur();
	nodePauseTime = movementDuration;


	myNode = (MobileNode *) (Node::get_node_by_address(nodeID));

	X1 = myNode->X();
	Y1 = myNode->Y();

	X2 = X1 + (20 * cos(nodeDirection));
	Y2 = Y1 + (20 * sin(nodeDirection));


	if(X2 <= 0)
	{
		X2 = 0;
		isOnBound = true;
	}

	if(X2 >= W_Area)
	{
		X2 = W_Area;
		isOnBound = true;
	}

	if(Y2 <= 0)
	{
		Y2 = 0;
		isOnBound = true;
	}

	if(Y2 >= H_Area)
	{
		Y2 = H_Area;
		isOnBound = true;
	}


	myNode->set_destination(X2, Y2, nodeSpeed);


	Scheduler::instance().schedule(eventHandler_, new MyEvent(&MyApplication::newRound), nodePauseTime);



	//printf("Node(%d) in %.4f has (X2=%.2f)\n", nodeID, NOW, X2);
	//printf("Node(%d) in %.4f has (X2=%.2f, Y2=%.2f)\n", nodeID, NOW, X2, Y2);
	//printf("Node(%d) in %.4f has (X2=%.2f, Y2=%.2f, Speed=%.2f\n", nodeID, NOW, X2, Y2, nodeSpeed);
	//printf("Node(%d) in %.4f has (X2=%.2f, Y2=%.2f, Speed=%.2f, movDur=%.2f)\n", nodeID, NOW, X2, Y2, nodeSpeed, movementDuration);


	//printf("Node(%d) Now is in (Y=%.2f, Y=%.2f)\n", nodeID, X_Cord, Y_Cord);

	//double remEnrgy = myNode->energy_model()->energy();
	//printf("Node(%d) has RemainingEnergy:%.6f at %.4f\n", nodeID, remEnrgy, NOW);

	/**
	 * Reschedule the "newRound()" method to invoke after "roundDur" seconds.
	 * "roundDur" is time needed to complete the one Round of simulation.
	 */

}

double MyApplication::calcDirection() {

	nodeDirection = rng.uniform(0,1) * M_PI;
	return nodeDirection;
}



double MyApplication::calcSpeed() {

	nodeSpeed = rng.uniform(1,5);
	return nodeSpeed;
}



double MyApplication::calcDisplacement() {

	displacement = 20;
	return displacement;

}


double MyApplication::calcMovementDur() {

	return (displacement/nodeSpeed);

}



