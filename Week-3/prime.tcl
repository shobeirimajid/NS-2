
if {$argc != 1} {

	# Must get a single argument or program fails.

	puts stderr "ERROR! ns called with wrong number of arguments !( $argc )"

	exit 1
} else {

	set j [lindex $argv 0]
}


proc prime {j} {

	# Computes all the prime numbers till j

	for {set a 2} {$a <= $j} {incr a} {

		set b 0

		for {set i 2} {$i < $a} {incr i} {

#			set d [expr fmod($a ,$i)]
			set d [expr $a % $i]

			if {$d ==0} {

				set b 1

			}
		}


#		if {$b ==1} {
#			puts "$a is not a prime number"
#		} else {
#			puts "$a is a prime number"
#		}


		switch $b {
		
			$b == 1 {
				puts "$a is not a prime number"
			}

			$b == 0 {
				puts "$a is a prime number"
			}

			default {}
		
		}

	}
}


prime $j

