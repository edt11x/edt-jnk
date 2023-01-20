#!perl
#
# Calculate mileages when I forget to write down the mileage.
#
use Date::Manip;
$main::TZ = "EST5EDT";

sub prtn {
   print "\n";
}


#************************************************************************
#
# NAME
#	yesNo - interprets a yes or no answer to a question
#
# SYNOPSIS
#	int
#	yesNo(ans_input, ans_default)
#	char	*ans_input;
#	int	ans_default;
#
# DESCRIPTION
#	This function takes a character string and attempts to decern if
#	the input is a positive (yes, true, etc) or negative answer and
#	returns TRUE(-1) or FALSE(0). If the input is not recognizeable,
#	the passed default (TRUE or FALSE) is chosen. This is primarily
#	for use with human interactions. If the value of the default is
#	not TRUE or FALSE, the calling function can recognize when the
#	input was not identified.
#
# RETURNS
#	TRUE if the answer was judged to be affirmative.
#	FALSE if the answer was judged to be negative.
#	default if the answer was not identifiable.
#
# CALLING FUNCTIONS
#
# FUNCTIONS CALLED
#	NONE
#
# WARNINGS
#	The strings is attacked with an upper case conversion.
#
# SEE ALSO
#	GRAPHX YESNO routine.
#
#                                                                  (edt)
#***********************************************************************/

sub yesNo {
    local($ans_input, $ans_default) = @_;
    local($i);
    local(@ans_true)  = ( "YES", "TRUE", "Y", "OK", "YEAH", "1", "YE",
	"SURE", "T", "-1");
    local(@ans_false) = ( "NO", "FALSE", "N", "ERROR", "NAY", "0",
	"NEGATIVE", "F");
	
    $ans_input =~ tr/a-z/A-Z/;
    chomp($ans_input);
    foreach (@ans_true) {
        if ($ans_input eq $_) {
            return !0;
        }
    }
    
    foreach (@ans_false) {
        if ($ans_input eq $_) {
            return 0;
        }
    }
    return $ans_default;
}

sub readYesNo {
    local($ans) = <>;
    return &yesNo($ans, 0);
}


print "Mileage Calculator";
&prtn;
&prtn;
$startingMileage = 0;
$startingDate    = 0;
$endingMileage   = 0;
$endingDate      = 0;
print "Do you have a starting mileage ? ";
$ans = <>;
if (&yesNo($ans, 0)) {
    print "Enter starting Mileage         : ";
    $startingMileage = <>;
}
print "Enter starting Date            : ";
$startingDate = <>;
$startingDate = &ParseDate($startingDate);

print "Do you have an ending mileage  ? ";
$ans = <>;
if (&yesNo($ans, 0)) {
    print "Enter Ending   Mileage         : ";
    $endingMileage = <>;
}
print "Enter Ending   Date            : ";
$endingDate    = <>;
$endingDate    = &ParseDate($endingDate);
print "Enter Mileage to Work One Way  : ";
$oneWay        = <>;

# count the working days between the start and end
$countDays = 0;
for ($i = $startingDate; $i < $endingDate; $i = &DateCalc($i, "+ 1 days", \$err)) {
    if (&Date_IsWorkDay($i)) {
        print &UnixDate($i, "%D"), "\n";
        $countDays++;
    }
}

# compute the minimum amount of mileage we need for those days
$minMileage = $oneWay * 2 * $countDays;

# if we have a starting mileage
if ($startingMileage) {
    # check to make sure that ending mileage is sufficient
    if ($startingMileage + $minMileage > $endingMileage) {
        print "Huston, we have a problem\n";
        print "Starting Mileage is                      : ", 
            $startingMileage, "\n";
        print "Minimum  Mileage Driven by Count of Days : ", 
            $minMileage, "\n";
        print "Ending   Mileage is                      : ",
            $endingMileage, "\n";
        print "Number of Days                           : ",
            $countDays, "\n";
        print "This wont work\n";
        exit 0;
    }

    # how many miles do we have left over to divide ?
    $remainderMiles = $endingMileage - $startingMileage - $minMileage;
    
} else {
    # Compute the starting mileage backwords
    $avgExtra = 32.0; # 32 miles per day extra, it's just a guess
    $remainderMiles = $avgExtra * $countDays;
    # compute starting mileage
    $startingMileage = $endingMileage - $remainderMiles - $minMileage;
}

print "Remaining Miles to Divide : ", $remainderMiles, "\n";
for ($i = $startingDate; $i < $endingDate; $i = &DateCalc($i, "+ 1 days", \$err)) {
    if (&Date_IsWorkDay($i)) {
        print &UnixDate($i, "%D"), "\t", $startingMileage, "\n";
        $avgExtra = $remainderMiles / $countDays;
        print "  average extra         : $avgExtra  \n";
        $thisExtra = rand $avgExtra;
        print "  this    extra         : $thisExtra \n";
        $startingMileage += $oneWay * 2 + $thisExtra;
        print "  next starting mileage : $startingMileage \n";
        $remainderMiles -= $thisExtra;
        print "  remainder miles       : $remainderMiles \n";
        $countDays--;
        print "  count of days         : $countDays \n";
        print "\nHit Return";
        $ans = <>;
    }
}
exit 0;

