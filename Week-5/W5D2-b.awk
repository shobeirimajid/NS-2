 BEGIN {
	 generatedPackets = 0; 
	 droppedPackets = 0;
	 receivedPackets = 0;
	 count = 0;
 }
 {
	 #packet delivery ratio
	 if ($1 == "+" && ($3 == 0 || $3 == 1) && ($5 == "tcp" || $5 == "cbr")) {
	 	generatedPackets++;
	 } else if(($1 == "r") && ($4 == 4 || $4 == 5) && ($5 == "tcp" || $5 == "cbr")) {
	 	receivedPackets++;
	 } else if ($1 == "d" && ($5 == "tcp" || $5 == "cbr")){
	 	droppedPackets++; 
	 }

	 #end-to-end delay
	 if ($1 == "+" && ($3 == 0 || $3 == 1) && ($5 == "tcp" || $5 == "cbr")) {
	 	start_time[$12] = $2;
	 } else if ($1 == "r" && ($4 == 4 || $4 == 5) && ($5 == "tcp" || $5 == "cbr")) {
	 	end_time[$12] = $2;
	 } else if($1 == "d" && ($5 == "tcp" || $5 == "cbr")) {
	 	end_time[$12] = -1;
	 }
 }
  
 END { 
	 for(i=0; i<=generatedPackets; i++) {

		 if(end_time[i] > 0) {
		 	delay[i] = end_time[i] - start_time[i];
		 	count++;
	 	}
	 	else
	 	{
	 		delay[i] = -1;
	 	}
	 }

	 for(i=0; i<count; i++) {
		 if(delay[i] > 0) {
		 	n_to_n_delay = n_to_n_delay + delay[i];
		 } 
	 }

	 if(count != 0)
		n_to_n_delay = n_to_n_delay/count;

	 print "\n";

	 print "GeneratedPackets = " generatedPackets " pkt";
	 print "Total Dropped Packets = " droppedPackets " pkt";
	 print "ReceivedPackets = " receivedPackets " pkt";
	 

	if(generatedPackets > 0)
		 print "Packet Delivery Ratio = " receivedPackets/generatedPackets*100"%";

	 
	 print "Average End-to-End Delay = " n_to_n_delay * 1000 " ms";
	 print "\n";
 }

