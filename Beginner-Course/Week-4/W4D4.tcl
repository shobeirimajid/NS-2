
###################################
# Initialization
###################################

# an object of Simulator
set ns [new Simulator]

# Start of Simulation
puts "Starting of Simulation at [$ns now]"

# flow Coloring  
$ns color 1 dodgerblue

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

# Node shaping !Shape can not be changed during simulation!
$n0 shape box
$n1 shape hexagon

# Node Coloring  
$n0 color dodgerblue
$n1 color orange

# Node labeling
$n0 label “Sourse”
$n1 label “Destination”

# Node lable coloring
$n0 label-color darkviolet
$n1 label-color darkviolet

# Node marking
$n0 add-mark m0 blue circle
$n1 add-mark m1 blue circle

#mark removing
$ns at 50 "$n0 delete-mark m0"
$ns at 50 "$n1 delete-mark m1"

# link definition
$ns duplex-link $n0 $n1 5Mb 10ms DropTail
$ns queue-limit $n0 $n1 50

# Link labeling
$ns duplex-link-op $n0 $n1 label "DropTail_5Mb_10ms"

# Link Coloring  
$ns duplex-link-op $n0 $n1 color red

# link Orientation
$ns duplex-link-op $n0 $n1 orient right

# queue positioning
$ns duplex-link-op $n0 $n1 queuePos 5


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
$ns at 5.0 "$ftp start"
$ns at 95.0 "$ftp stop"
$ns at 100.0 "finish"

# NAM Annotation
$ns at 0.0 "$ns trace-annotate \"Start Simulation\""
$ns at 5.0 "$ns trace-annotate \"Start FTP Traffic from N0 to N1\""
$ns at 95.0 "$ns trace-annotate \"Stop FTP Traffic from N0 to N1\""
$ns at 99.9 "$ns trace-annotate \"Stop Simulation\""

###################################
# Procedures
###################################

# finish procedure
proc finish {} {
	global ns tracefile namfile
	$ns flush-trace
	close $tracefile
	close $namfile
	puts "Ending the Simulation at [$ns now]"
	exec nam out.nam &
	exit 0
}


###################################
# Running
###################################

$ns run

