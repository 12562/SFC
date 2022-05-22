#!/bin/awk -f

BEGIN{
	printf "Average value of knowledge gained (on a scale of 1 to 10) before and after the task is as follows: \n"

	FS=",";
	sum_scale_know_before = 0;
	sum_scale_know_after = 0;
	know_less_than_eq_two_before = 0;
	know_great_than_eq_five_after = 0;
}

{
	if(NR > 1)
	{
		sum_scale_know_before = sum_scale_know_before + $1;
		sum_scale_know_after = sum_scale_know_after + $2;
		if($1 <= 2)
			know_less_than_eq_two_before += 1;

		if($2 >= 5)
			know_great_than_eq_five_after += 1;
	}
}

END{
	printf "Before: %.3f\n", sum_scale_know_before/(NR-1);
	printf "After: %.3f\n",  sum_scale_know_after/(NR-1);
	percen_incr = ( ( know_great_than_eq_five_after - know_less_than_eq_two_before ) / know_less_than_eq_two_before ) * 100;
	printf "\nPercentage increase in knowledge gained from level 2 or less before to level 5 or more after: %.3f\n", percen_incr;
}
