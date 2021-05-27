#===================================
#     Simulation parameters setup
#===================================
set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
Phy/WirelessPhy set bandwidth_ 2mb        ;#Data Rate
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue        ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 50                         ;# max packet in ifq
set val(nn)     110                          ;# number of mobilenodes
set opt(cp)	 "/home/meysam/work/ns-allinone-2.34/ns-2.34/tcl/mobility/scene/flow6"
set opt(sc)      "/home/meysam/work/ns-allinone-2.34/ns-2.34/tcl/mobility/scene/mob_rate"
set val(rp)    AODV                    ;# routing protocol
set val(minSpeed) 0.0                         ;# movement minimum speed [km/h]
set val(maxSpeed) 10.0                        ;# movement maximum speed [km/h]
set val(minPause) 0.0                        ;# movement minimum pause time [s]
set val(maxPause) 5.0                       ;# movement maximum pause time [s]
set val(movementStart) 10.0                ;# movement start time [s]
set val(x)      1250                     ;# X dimension of topography
set val(y)      1250                     ;# Y dimension of topography
set val(stop)   50.0                      ;# time of simulation end
set val(throughput)        5.4                      ;# CBR rate (<= 5.4Mb/s)


#==================================

#==================================
#        Initialization        
#===================================
#Create a ns simulator
set ns_ [new Simulator]

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)AODV	
#create-god $val(nn)
#
# Create God
#
set god_ [create-god $val(nn)]

#Open the NS trace file
set tracefile [open xrcc-6.tr w]
$ns_ trace-all $tracefile

#Open the NAM trace file
set namfile [open xrcc-6.nam w]
$ns_ namtrace-all $namfile
$ns_ namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel

#===================================
#     Mobile node parameter setup
#===================================
$ns_ node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan \
                -topoInstance  $topo \
                -energyModel    "EnergyModel" \
                -initialEnergy  40 \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      ON \
                -movementTrace OFF

#===================================
#        Nodes Definition        
#===================================
#Create 30 nodes
for {set i 0} {$i < $val(nn) } { incr i } {
     set node_($i) [$ns_ node]
     $node_($i) random-motion 1
     $node_($i) start
}
source "/home/meysam/work/ns-allinone-2.34/ns-2.34/tcl/mobility/scene/mob_rate"
#===================================
#        Agents Definition        
#===================================
#===================================
#        Applications Definition        
#===================================
source "/home/meysam/work/ns-allinone-2.34/ns-2.34/tcl/mobility/scene/flow6"
#===================================

#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns_ tracefile namfile
    $ns_ flush-trace
    close $tracefile
    close $namfile

   
}
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns_ at $val(stop) "\$node_($i) reset"
}
$ns_ at $val(stop) "$ns_ nam-end-wireless $val(stop)"
$ns_ at $val(stop) "finish"
$ns_ at $val(stop) "puts \"DONE\" ; $ns_ halt"
$ns_ run
