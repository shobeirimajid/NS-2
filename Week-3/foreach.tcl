

foreach {i} {1 2 3 4 5 6} {

	if {$i<=3} continue

	set idx [expr $i - 1]

	for {set j 0} {$j < $idx} {incr j} {

		#if {$i>3} break

		puts -nonewline "$i"
	}

	puts "$i"
}
