set lower 0
set upper 200
set step 50
set fahr $lower

while {$fahr < $upper} {

	set celsius [expr 5*($fahr - 32)/9]
	puts -nonewline "Fahrenheit / Celsius : $fahr / $celsius"
	set fahr [expr $fahr + $step]
	puts "\t Enter \"y\" to continue ..."

	flush stdout
	set cont 0

	while { $cont != y } {
		gets stdin cont
	}
}

