#!/bin/awk -f

BEGIN{
	FS=",";
	know_less_than_eq_two_before = 0;
	know_great_than_eq_five_after = 0;
}

{
	if(NR > 0)
	{
		if($1 <= 1)
			know_less_than_eq_two_before = 1;

		if($2 >= 8)
			know_great_than_eq_five_after = 1;
	}
}

END{
	percen_incr = ( ( know_great_than_eq_five_after - know_less_than_eq_two_before ) / know_less_than_eq_two_before);
	printf "\nPercentage increase in knowledge gained from level 2 or less before to level 5 or more after: %.3f\n", percen_incr;
}
