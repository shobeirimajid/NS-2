
# an object of Simulator
set ns [new Simulator]

# Start of Simulation
puts "Starting of Simulation at [$ns now]"


# textual trace file
set tracefile [open out.tr w]
$ns trace-all $tracefile

# nam trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile



# network configuration



# Agent and Application Assignment



# Scheduling the events
$ns at 100 "finish"


# finish procedure
proc finish {} {
	global ns tracefile namfile
	$ns flush-trace
	close $tracefile
	close $namfile
	exec nam out.nam &
	puts "Ending the Simulation at [$ns now]"
	exit 0
}

# runnung the simulation
$ns run

