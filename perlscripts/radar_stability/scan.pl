
sub computeError {
local($thisTime) = @_;
   $thisError = 2 * $pi - 
        sin($vy * $thisTime + $ya) / cos($vx * $thisTime + $xa) + 
	sin($ya) / cos($xa) - 2 * $pi * $thisTime / $scanPeriod;
   return(abs($thisError));
}

#
# solve for scan time
#
$xa = 20;         # 20nmi
$ya = 10;         # 10nmi
$vx = -0.027777;  # 2 nmi/sec
$vy =  0;         # 0 nmi/sec
$scanPeriod = 10; # 10 seconds
$pi         = 3.1415926;
$tbLow      = 9.0;
$tbHigh     = 10.0;
$errorMid   = 9999.0;
while ($errorMid > 0.00001) {
   $tbMid = ($tbLow + $tbHigh ) / 2.0;
   $errorLow  = &computeError($tbLow);
   $errorHigh = &computeError($tbHigh);
   $errorMid  = &computeError($tbMid);
   if ($errorLow < $errorHigh) {
	$tbHigh = $tbMid;
   } else {
 	$tbLow  = $tbMid;
   }
   print "This Error is : $errorMid, This Time is : $tbMid\n";
}
