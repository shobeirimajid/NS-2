				        
# ########################################################################################
#                                               				         #
# 	Simulation parameters setup							 #
# 									                 #								                          
# ########################################################################################

set val(chan) 		Channel/WirelessChannel      			;# Channel Type
set val(prop) 		Propagation/TwoRayGround     			;# Radio-Propagation Model
set val(netif) 		Phy/WirelessPhy              			;# Network Interface Type

# Phy/WirelessPhy 	set CPThresh_ 10.0         			;#Collision Threshold
Phy/WirelessPhy 	set CSThresh_ 5.011872e-12 			;#Carrier Sense Power Threshold	= 22.5 m
Phy/WirelessPhy 	set RXThresh_ 5.82587e-09  			;#Receive Power Threshold = 22.5 m

set val(mac) 		Mac/802_11                   			;# MAC Type
set val(ifq) 		Queue/DropTail/PriQueue      			;# Interface Queue Type
set val(ll) 		LL                           			;# Link Layer Type
set val(ant) 		Antenna/OmniAntenna          			;# Antenna Model
set val(ifqlen) 	200                          			;# Queue Length
set val(rp) 		AODV                         			;# Routing Protocol

set val(x) 		300                          			;# X Dimension of Topography
set val(y) 		300                          			;# Y Dimension of Topography

set val(nsn) 		5                      				;# Number of Sensor Nodes

set val(sn_size) 	10                            			;# Size of Sensor Nodes
set val(bs_size) 	20                            			;# Size of Sensor Nodes

set val(stop) 		300                         			;# simulation_time 

# ########################################################################################
#                                               				         #
#	HEADER Management     		                 				 #
# 									                 #								                          
# ########################################################################################

# TODO: Reduces memory usages and simulation run-time.
# common cmn header is always included.
# Additionally you have to add all further packet headers used by your simulation.
# The example can be used for basic simulations (no ARP, no routing protocol ).

# remove-all-packet-headers
# add-packet-header LL IP Mac

# ########################################################################################
#                                               				         #
#	Initialization				         				 #
# 									                 #								                          
# ########################################################################################

puts ""
puts "------------------------------------------"
puts "	Initialization			  	"
puts "------------------------------------------"
puts ""

#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nsn)

#Open the NS trace file
set tracefd [open maApp.tr w]
$ns trace-all $tracefd

#Open the NAM trace file
set namtrace [open maApp.nam w]
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

#Create wireless channel
set chan [new $val(chan)]

# ########################################################################################
#                                               				         #
#	Mobile node parameter setup				         		 #
# 									                 #								                          
# ########################################################################################

$ns node-config -adhocRouting $val(rp) \
             -llType $val(ll) \
             -macType $val(mac) \
             -ifqType $val(ifq) \
             -ifqLen $val(ifqlen) \
             -antType $val(ant) \
             -propType $val(prop) \
             -phyType $val(netif) \
             -channel $chan \
             -topoInstance $topo \
             -agentTrace ON \
             -routerTrace ON \
             -macTrace  ON \
             -movementTrace ON \
	     -energyModel EnergyModel \
	     -rxPower 0.3 \
	     -txPower 0.6 \
	     -initialEnergy 3.0 \

			 			 
 # ########################################################################################
 #                                               				          #
 #	BaseStation  Definition					          	  	  #
 # 									                  #								                          
 # ########################################################################################
 
# Create the sink with id=0 
# Because it is the first node creation during this namespace
# Set the size of sink
# Place the sink in the center of area
# Tell time of ending the simulationl

puts ""
puts "------------------------------------------"
puts "	BaseStation Definition			"
puts "------------------------------------------"
puts ""

set node_(0) [$ns node]

$node_(0) set X_ [ expr { $val(x) / 2 } ]
$node_(0) set Y_ [ expr { $val(y) / 2 } ]
$node_(0) set Z_ 0.0

# $node_(0) label-color blue
# $ns at 0.0 "$node_(0) label-color blue"

$node_(0) label "BS"

# $node_(0) label-at up
# $node_(0) shape hexagon

$node_(0) color blue
$ns at 0.0 "$node_(0) color blue"

#Create a agent (a traffic sink) and attach it to BS (node n0)
set agent(0) [new Agent/MyAgent]
$ns attach-agent $node_(0) $agent(0)

$ns initial_node_pos $node_(0) $val(bs_size)
$ns at $val(stop) "$node_(0) reset;"

set sinkid [$node_(0) id]

set app(0) [new Application/MyApplication $sinkid]
$app(0) attach-agent $agent(0)

#$ns at 1.0 "$app(0) start"
	
puts "The sink is created with id=$sinkid"

# ########################################################################################
#                                               				         #
#	SENSOR				                 				 #
# 									                 #								                          
# ########################################################################################

# Create Sensor Nodes from id=1 to val(nsn)
# Tell Time of Ending the Simulation

puts ""
puts "------------------------------------------"
puts "	Sensor Definition			"
puts "------------------------------------------"
puts ""

puts " Creating Sensors ... "

for {set i 1} {$i <= $val(nsn)} {incr i} {
	set node_($i) [$ns node]
	$ns at $val(stop) "$node_($i) reset"
}

# Create Transfer Agent and Attach to Node
# Crate Application and Attach to Transfer Agent
# Schedule to Start Application at Certain Time

for {set i 1} {$i <= $val(nsn)} {incr i} {

	set nodeid [$node_($i) id]
	
	set agent($i) [new Agent/MyAgent]
	$ns attach-agent $node_($i) $agent($i)
	
	set app($i) [new Application/MyApplication $nodeid]
	$app($i) attach-agent $agent($i)
	
	$ns at 1.0 "$app($i) start"
}

# Connecting all Agents to each other and to Sink to setup a full duplex network.
puts " Connecting Agents ... "

for {set i 0} {$i <= $val(nsn)} {incr i} { 
	for {set j 0} {$j <= $val(nsn)} {incr j} {		
		if {$i != $j} {	
			# puts "($i, $j)"
			$ns connect $agent($i) $agent($j)
		}
	}	
}

# randomly deploy sensor nodes uniformly in area and set the size of sensor nodes to val(sn_size)
puts "Uniform Deployment of Sensors..."

 for {set i 1} {$i <= $val(nsn)} {incr i} {
	 
	$node_($i) set X_ [ expr { $val(x) * rand()} ]
	$node_($i) set Y_ [ expr { $val(y) * rand()} ]
	$node_($i) set Z_ 0.0
	$ns initial_node_pos $node_($i) $val(sn_size)
 }
 
# ########################################################################################
#                                               				         #
#	Termination				         				 #
# 									                 #								                          
# ########################################################################################
 
proc finish {} {
	
	global ns tracefd namtrace
	$ns flush-trace
	close $tracefd
	close $namtrace
	exec nam maApp.nam &
	puts ""
	$ns halt
	exit 0
}


$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"

puts "	Start Simulation ...			  "

$ns run


