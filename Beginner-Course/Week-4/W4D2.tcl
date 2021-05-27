
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


###################################
# network configuration
###################################

# node definition
set n0 [$ns node]
set n1 [$ns node]

# get node IDs
set nodeID0 [$n0 id]
set nodeID1 [$n1 id]
puts "nodes $nodeID0 and $nodeID1 created!"


# link definition
$ns duplex-link $n0 $n1 5Mb 10ms DropTail
$ns queue-limit $n0 $n1 50


###################################
# Agent and Application Assignment
###################################


# Scheduling the events
$ns at 100.0 "finish"


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

