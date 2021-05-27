BEGIN {
	drop = 0
	recv = 0
	pktCnt = 0
 }
 
 {
	if ($1 == "+" && ($3 == 0 || $3 == 1) && ($5 == "tcp" || $5 == "cbr")) 
		pktCnt = pktCnt + 1
	else if ($1 == "d" && ($5 == "tcp" || $5 == "cbr"))
		 drop = drop + 1
 }
 
 END {
	print("Generated Packets: ", pktCnt)
        print("Drop numbers: ",drop)
	
	recv = pktCnt - drop

	print("Receive numbers: ",recv)

	print "Packet_Delivery_Ratio = " recv/pktCnt*100
 }
