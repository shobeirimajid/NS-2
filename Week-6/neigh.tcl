
###################################
# Initialization
###################################

# an object of Simulator
set ns [new Simulator]

# Start of Simulation
puts "Starting of Simulation at [$ns now]"

# flow Coloring  
$ns color 1 darkviolet
$ns color 2 dodgerblue

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
set n(0) [$ns node]
set n(1) [$ns node]
set n(2) [$ns node]
set n(3) [$ns node]
set n(4) [$ns node]
set n(5) [$ns node]

set n(6) [$ns node]
set n(7) [$ns node]

set n(8) [$ns node]
set n(9) [$ns node]

# Node Coloring  
$n(0) color darkviolet
$n(1) color dodgerblue
$n(2) color orange
$n(3) color green
$n(4) color darkviolet
$n(5) color dodgerblue

$n(6) color orange
$n(7) color green

$n(8) color orange
$n(9) color green

# Node labeling
$n(0) label “TCP_Src”
$n(1) label “UDP_Src”
$n(4) label “TCP_Sink”
$n(5) label “Null”

# link definition
$ns duplex-link $n(0) $n(8) 2Mb 10ms DropTail
$ns duplex-link $n(1) $n(8) 2Mb 10ms DropTail
$ns duplex-link $n(8) $n(9) 0.3Mb 100ms DropTail
$ns duplex-link $n(9) $n(4) 0.5Mb 40ms DropTail
$ns duplex-link $n(9) $n(5) 0.5Mb 40ms DropTail

$ns duplex-link $n(0) $n(2) 2Mb 10ms DropTail
$ns duplex-link $n(2) $n(3) 0.3Mb 100ms DropTail
$ns duplex-link $n(3) $n(4) 0.5Mb 40ms DropTail

$ns duplex-link $n(0) $n(6) 2Mb 10ms DropTail
$ns duplex-link $n(6) $n(7) 0.3Mb 100ms DropTail
$ns duplex-link $n(7) $n(4) 0.5Mb 40ms DropTail


#Set Queue Size of link (n2-n3) to 20
$ns queue-limit $n(2) $n(3) 20
$ns queue-limit $n(3) $n(2) 20

#Set Queue Size of link (n6-n7) to 20
$ns queue-limit $n(6) $n(7) 20
$ns queue-limit $n(7) $n(6) 20

#Set Queue Size of link (n8-n9) to 20
$ns queue-limit $n(8) $n(9) 20
$ns queue-limit $n(9) $n(8) 20

# link Orientation
$ns duplex-link-op $n(0) $n(8) orient right-down
$ns duplex-link-op $n(1) $n(8) orient right-up
$ns duplex-link-op $n(8) $n(9) orient right
$ns duplex-link-op $n(9) $n(4) orient right-up
$ns duplex-link-op $n(9) $n(5) orient right-down

$ns duplex-link-op $n(0) $n(2) orient right-up
$ns duplex-link-op $n(2) $n(3) orient right
$ns duplex-link-op $n(3) $n(4) orient right-down

$ns duplex-link-op $n(0) $n(6) orient right
$ns duplex-link-op $n(6) $n(7) orient right
$ns duplex-link-op $n(7) $n(4) orient right

###################################
# Agent and Application Assignment
###################################

#setup a TCP connection
set tcp [new Agent/TCP]
$ns attach-agent $n(0) $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n(4) $sink
$ns connect $tcp $sink
$tcp set fid_ 1
$tcp set packetSize_  552

#Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp


#setup a UDP connection
set udp [new Agent/UDP]
$ns attach-agent $n(1) $udp
set null [new Agent/Null]
$ns attach-agent $n(5) $null
$ns connect $udp $null
$udp set fid_ 2

#setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packetSize_ 1000
$cbr set rate_ 0.35Mb
$cbr set random_ false

###################################
# Scheduling
###################################

# Scheduling the events
$ns at 1.0 "$ftp start"
$ns at 99.0 "$ftp stop"

$ns at 1.0 "$cbr start"
$ns at 99.0 "$cbr stop"


# NAM Annotation
$ns at 0.0 "$ns trace-annotate \"Start Simulation\""

$ns at 10.0 "$ns trace-annotate \"Start FTP Traffic from N0 to N4\""
$ns at 99.0 "$ns trace-annotate \"Stop FTP Traffic from N0 to N4\""

$ns at 1.0 "$ns trace-annotate \"Start CBR Traffic from N1 to N5\""
$ns at 70.0 "$ns trace-annotate \"Stop CBR Traffic from N1 to N5\""

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
	#exec xgraph WinFile &
	exit 0
}
$ns at 100.0 "finish"


proc printNeighbors {node} {

	global ns

	set NL [$node neighbors]

	puts "----------------------"
	puts "Neighbors of Node([$node id]):"

	foreach {n} $NL {

		set nid [$n id]
		puts -nonewline "$nid "
	}

	puts ""
	
}

proc TotalNeighbors {nn} {

	global ns n

	for {set i 0} {$i < $nn} {incr i} {

		printNeighbors $n($i)
	}
}

$ns at 20 "TotalNeighbors 10"


###################################
# Running
###################################

$ns run

