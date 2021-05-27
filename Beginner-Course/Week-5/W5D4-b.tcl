
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

# file to collect tcp window sizes
set winfile [open WinFile w]

# file to collect queue monitoring information
set qmFile [open QueueMon w]

# file to collect flow monitoring information
set fmFile [open FlowMon w]

###################################
# network configuration
###################################

# node definition
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

set n6 [$ns node]
set n7 [$ns node]

# Node shaping !Shape can not be changed during simulation!
#$n0 shape box
#$n1 shape hexagon

# Node Coloring  
$n0 color darkviolet
$n1 color dodgerblue
$n2 color orange
$n3 color green
$n4 color darkviolet
$n5 color dodgerblue

$n6 color orange
$n7 color green

# Node labeling
$n0 label “TCP_Src”
$n1 label “UDP_Src”
$n4 label “TCP_Sink”
$n5 label “Null”

# Node lable coloring
#$n0 label-color darkviolet
#$n1 label-color darkviolet

# Node marking
#$n0 add-mark m0 blue circle
#$n1 add-mark m1 blue circle

#mark removing
#$ns at 50 "$n0 delete-mark m0"
#$ns at 50 "$n1 delete-mark m1"

# link definition
$ns duplex-link $n0 $n6 2Mb 10ms DropTail
$ns duplex-link $n1 $n6 2Mb 10ms DropTail
$ns duplex-link $n6 $n7 0.3Mb 100ms DropTail
$ns duplex-link $n7 $n4 0.5Mb 40ms DropTail
$ns duplex-link $n7 $n5 0.5Mb 40ms DropTail

$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.3Mb 100ms DropTail
$ns duplex-link $n3 $n4 0.5Mb 40ms DropTail


#Set Queue Size of link (n2-n3) to 20
$ns queue-limit $n2 $n3 20
$ns queue-limit $n3 $n2 20

#Set Queue Size of link (n6-n7) to 20
$ns queue-limit $n6 $n7 20
$ns queue-limit $n7 $n6 20

# Link labeling
#$ns duplex-link-op $n0 $n2 label "DropTail_2Mb_10ms"
#$ns duplex-link-op $n1 $n2 label "DropTail_2Mb_10ms"
#$ns duplex-link-op $n2 $n3 label "DropTail_0.3Mb_100ms"

#$ns duplex-link-op $n3 $n4 label "DropTail_0.5Mb_40ms"
#$ns duplex-link-op $n3 $n5 label "DropTail_0.5Mb_40ms"

# Link Coloring  
#$ns duplex-link-op $n0 $n1 color red

# link Orientation
$ns duplex-link-op $n0 $n6 orient right-down
$ns duplex-link-op $n1 $n6 orient right-up
$ns duplex-link-op $n6 $n7 orient right
$ns duplex-link-op $n7 $n4 orient right-up
$ns duplex-link-op $n7 $n5 orient right-down

$ns duplex-link-op $n0 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n3 $n4 orient right-down

# queue positioning
#$ns duplex-link-op $n0 $n1 queuePos 5

# get node IDs
#set nodeID0 [$n0 id]
#set nodeID1 [$n1 id]
#puts "nodes $nodeID0 and $nodeID1 created!"

# queue tracing
#$ns trace-queue $n2 $n3 $tracefile
#$ns namtrace-queue $n2 $n3 $namfile

# Queue Monitoring
set qmon [$ns monitor-queue $n6 $n7 $qmFile 0.1];
[$ns link $n6 $n7] start-tracing;

###################################
# Agent and Application Assignment
###################################

#setup a TCP connection
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink
$ns connect $tcp $sink
$tcp set fid_ 1
$tcp set packetSize_  552

#Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp


#setup a UDP connection
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n5 $null
$ns connect $udp $null
$udp set fid_ 2

#setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packetSize_ 1000
$cbr set rate_ 0.35Mb
$cbr set random_ false

# Flow Monitoring
set fmon [$ns makeflowmon Fid]
set flink [$ns link $n6 $n7]
$ns attach-fmon $flink $fmon
$fmon attach $fmFile
$ns at 99 "$fmon dump"

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


# scheduling link failure
$ns rtmodel-at 10.0 down $n2 $n3
$ns rtmodel-at 30.0 up $n2 $n3

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
	exec xgraph WinFile &
	exit 0
}
$ns at 100.0 "finish"

proc plotWindow {tcpSource file} {
	global ns
	set time 0.1
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $file "$now $cwnd"
	$ns at [expr $now+$time] "plotWindow $tcpSource $file"
}
$ns at 0.1 "plotWindow $tcp $winfile"


###################################
# Running
###################################

$ns run