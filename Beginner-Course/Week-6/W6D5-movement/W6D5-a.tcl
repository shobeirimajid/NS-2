
# ======================================================================
# Define options
# ======================================================================
set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             2                          ;# number of mobilenodes
set val(rp)             AODV                       ;# routing protocol
set val(x) 		300			   ;# width of Area
set val(y) 		300			   ;# Height of Area

# ======================================================================
# Main Program
# ======================================================================


#
# Initialize Global Variables
#
set ns_		[new Simulator]

set tracefd     [open simple.tr w]
$ns_ trace-all $tracefd

set namtrace    [open simple.nam w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y) 

# set up topography object
set topo       [new Topography]

$topo load_flatgrid $val(x) $val(y) 

#
# Create God
#
create-god $val(nn)

#
#  Create the specified number of mobilenodes [$val(nn)] and "attach" them to the channel. 
#  Here two nodes are created : node(0) and node(1)
#

# configure node

        $ns_ node-config -adhocRouting $val(rp) \
			 -llType $val(ll) \
			 -macType $val(mac) \
			 -ifqType $val(ifq) \
			 -ifqLen $val(ifqlen) \
			 -antType $val(ant) \
			 -propType $val(prop) \
			 -phyType $val(netif) \
			 -channelType $val(chan) \
			 -topoInstance $topo \
			 -agentTrace ON \
			 -routerTrace ON \
			 -macTrace OFF \
			 -movementTrace ON
			
			 
	for {set i 0} {$i < $val(nn) } {incr i} {
		set node_($i) [$ns_ node]	
		$node_($i) random-motion 1		;# Enable random motion
	}

#
# Provide initial (X,Y, for now Z=0) co-ordinates for mobilenodes
#
$node_(0) set X_ 10.0
$node_(0) set Y_ 10.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 100.0
$node_(1) set Y_ 100.0
$node_(1) set Z_ 0.0


#
# Now produce some simple node movements

# Node_(1) then starts to move away from node_(0)
#$ns_ at 10.0 "$node_(1) setdest 270.0 270.0 5.0"

# Node_(1) starts to move towards node_(0)
#$ns_ at 50.0 "$node_(1) setdest 100.0 100.0 5.0" 


# Setup traffic flow between nodes
# TCP connections between node_(0) and node_(1)

set tcp [new Agent/TCP]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp
$ns_ attach-agent $node_(1) $sink
$ns_ connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns_ at 10.0 "$ftp start" 


# Define node initial position in nam
for {set i 0} {$i < $val(nn)} { incr i } {
	# 30 defines the node size for nam
	$ns_ initial_node_pos $node_($i) 30
}


#
# Tell nodes when the simulation ends
#
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at 100.0 "$node_($i) reset";
}

$ns_ at 1.0 "$node_(0) start"
$ns_ at 1.0 "$node_(1) start"


$ns_ at 100.0 "stop"
$ns_ at 100.01 "puts \"NS EXITING...\" ; $ns_ halt"


proc stop {} {
    global ns_ tracefd
    $ns_ flush-trace
    close $tracefd
    exec nam simple.nam &
}


puts "Starting Simulation..."
$ns_ run

