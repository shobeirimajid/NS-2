
if {$argc != 1} {

	# Must get a single argument or program fails.
	puts stderr "ERROR! ns called with wrong number of arguments !( $argc )"
	exit 1

} else {
	set f [lindex $argv 0];
}

proc Factorial {x} {

#	for {set result 1} {$x > 1} {set x [expr $x - 1]} {
#		set result [expr $result * $x]
#	}

	set result 1

	while { $x > 1 } {
		set result [expr $result * $x]
		#set x [expr $x - 1]
		incr x -1
	}

	return $result
}


set res [ Factorial $f ]

puts " Factorial of $f is $res "

