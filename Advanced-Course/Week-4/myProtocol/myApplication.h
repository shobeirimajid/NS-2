
#ifndef _MY_APPLICATION_
#define _MY_APPLICATION_

#define NOW Scheduler::instance().clock()

#include <fstream>
#include <iostream>
#include <list>

#include <string.h>
#include <scheduler.h>
#include <tclcl.h>

#include <agent.h>
#include <node.h>
#include <mobilenode.h>

#include <tools/rng.h>

using namespace std;


/**
 * MyApplication Base Class.
 */
class MyApplication : public Application
{
protected:

	/**
	 * Delegation to Schedule some Events During Simulation.
	 */
	class MyEvent : public Event
	{
		public:
			typedef void (MyApplication::*delegation) (void);

		private:
			delegation delegate_;

		public:
			MyEvent(delegation delegate)
			{
				this->delegate_ = delegate;
			}

			delegation getDelegate() { return delegate_; }
			void setDelegate(delegation delegate) { delegate_ = delegate; }

			inline void executeDelegation(MyApplication * app)
			{
				(app->*delegate_)();
			}
	};


	/**
	 * Handler to Execute Events.
	 */
	class MyEventHandler : public Handler
	{
		private:
			MyApplication * app_;
		public:
			MyEventHandler(MyApplication * app) { app_ = app; }

			void handle(Event * event)
			{
				MyEvent * myevent = (MyEvent *) event;
				myevent->executeDelegation(app_);
			}
	};


	/**
	 * Event Handler
	 */
	MyEventHandler	* eventHandler_;


	public:

		MyApplication(int NodeID);
		~MyApplication();
		int command(int, const char* const*); 	// Interface to running NS2 commands from TCL level

		int nodeID;
		void newRound();

		MobileNode 	*myNode;

		RNG rng;

		double calcDirection();
		double calcSpeed();
		double calcDisplacement();
		double calcMovementDur();

		double nodeDirection;
		double nodeSpeed;
		double displacement;
		double movementDuration;

		double X1;
		double X2;
		double Y1;
		double Y2;

		double W_Area;
		double H_Area;

		bool isOnBound;
		double nodePauseTime;

};

#endif









