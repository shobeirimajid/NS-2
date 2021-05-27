BEGIN {
	initEnrg = 25;
	totNodeCnt = 2;
	totConsEnrg = 0;
	avgConsEnrg = 0;
}
{
	#Remaining Energies
	remEnrgs[$3] = $14;
}
END {
	#Consumed Energies
	for(i=0; i<totNodeCnt; i++) {
		consEnrgs[i] = initEnrg - remEnrgs["_"i"_"];
		totConsEnrg += consEnrgs[i];
	}

	avgConsEnrg = totConsEnrg / totNodeCnt;

	print "\n";
	print "Total Consumed Energies = " totConsEnrg " joule";
	print "Average Consumed Energies = " avgConsEnrg " joule";
	print "\n";
}