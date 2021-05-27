
###################################
# Initialization
###################################

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

# link definition
$ns duplex-link $n0 $n1 5Mb 10ms DropTail
$ns queue-limit $n0 $n1 50

# get node IDs
set nodeID0 [$n0 id]
set nodeID1 [$n1 id]
puts "nodes $nodeID0 and $nodeID1 created!"


###################################
# Agent and Application Assignment
###################################

#setup a TCP connection
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink
$ns connect $tcp $sink
$tcp set fid_ 1
$tcp set packetSize_  552

#Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp


###################################
# Scheduling
###################################

# Scheduling the events
$ns at 0.1 "$ftp start"
$ns at 90.0 "$ftp stop"
$ns at 100.0 "finish"
$ns at 100.0 "puts \"Ending the Simulation at [$ns now]\"; $ns halt"


###################################
# Procedures
###################################

# finish procedure
proc finish {} {
	global ns tracefile namfile
	$ns flush-trace
	close $tracefile
	close $namfile
	exec nam out.nam &
	exit 0
}

###################################
# Running
###################################

$ns run

