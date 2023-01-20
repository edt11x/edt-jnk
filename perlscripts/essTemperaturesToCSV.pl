#! perl
use strict;
use warnings;

use lib 'r:/tools/PerlScripts/lib';
use OtpFaults;
use EuCbitFaults;
use EuPostFaults;
use DpCbitFaults;
use DpPostFaults;
use DuFaults;

use File::Glob ':glob';
use GD::Graph::bars;
use Getopt::Long;
use List::MoreUtils qw(apply true uniq);
use List::Util qw(max min sum);
use Pod::Usage;
use Regexp::Common;
use Scalar::MoreUtils qw(define);
use Time::Local;
use Time::localtime;
use Win32::Autoglob;

my $ESSMode           = "PCD";
my $MTE               = "MTE #3";
my $EU                = "EU #2028";
my $debugInfo         = 0;
my $noPlot            = 0;
my $help              = 0;
my $man               = 0;
my $fileList          = '';
my $directory         = '.';
my $summaryFile       = "J:/ESS/summary.csv";
my $verbose           = 0;
# Floating Point Number Regular Expression
my $floatingNumberRegEx = qr/[-+]?[0-9]*\.?[0-9]+/;
# Temperature Regular Expression
# What does a temperature look like in OTP Output?
# -20, -20.9, 30, 34.0
my $temperatureRegEx = $floatingNumberRegEx;
# Voltage Measurement
# Can a voltage be reported as a negative?
my $voltageRegEx = $floatingNumberRegEx;
# ETI Value Regular Expression
# eg 0831:36:31
my $etiValueRegEx = qr/[0-9]+:[0-9]{2}:[0-9]{2}/;
# Discrete Inputs Value
my $discreteInRegEx = qr/[0-9A-F]{5}/;
# Discrete Outputs Value
my $discreteOutRegEx = qr/[0-9A-F]{2}/;
my $leftOrRightRegEx = qr/\s*(Left|Right)\s+/;
# Cycle Count Regular Expression.
# The leading part of the summary line contains the test count, test failures,
# wall or chamber time, temperature and then left or right.
# For example,
#     63    4 22:00:22 Amb Left
#                            $1      $2      $3                 $4
my $cycleCountRegEx = qr/^\s*(\d+)\s+(\d+)\s+(\d\d:\d\d:\d\d)\s+(${temperatureRegEx}|Amb)/;
# Power Supply status regular expression.
# This should be a string of four characters, either "p" or "f" for pass or
# fail older logs will have them in upper case, newer logs will have them in
# lower case We expect something like " Left  pppp " or "Right pfpp "
my $powerSupplyRegEx  = qr/${leftOrRightRegEx}([pfPF]{4}|EMI)\s+/;
# Words and Bits Regular Expression
# There are a number of places where we decode something like G200400000f, where
# G2 indicates the second 32 bit word of the general purpose results and then the
# 32 bits of result for that word.
my $wordsBitsRegEx = qr/([0-9]{1,2})([0-9a-fA-F]{8})/;
my @tempMeasOrderedList = ( "SM", "SC", "VP", "IO", "FC", "PS", "DM", "DC", "DB", "DL", "DH", "DO", "DD" );
my $powerCycleKey;
my @powerCycleList;
my %powerCycleErrors;
my %specificErrorList;
my %temperatureMeasurements =
(
    "EU" => { "Left"  => { "SM" => { title => "SP   Module ", arr => [] },
                           "SC" => { title => "SP   CPU    ", arr => [] },
                           "VP" => { title => "VP   Module ", arr => [] },
                           "IO" => { title => "IO   Module ", arr => [] },
                           "FC" => { title => "FC   Module ", arr => [] },
                           "PS" => { title => "LVPS Module ", arr => [] },
                           "DM" => { title => "DP   Module ", arr => [] },
                           "DC" => { title => "DP   CPU    ", arr => [] } },
              "Right" => { "SM" => { title => "SP   Module ", arr => [] },
                           "SC" => { title => "SP   CPU    ", arr => [] },
                           "VP" => { title => "VP   Module ", arr => [] },
                           "PS" => { title => "LVPS Module ", arr => [] },
                           "DM" => { title => "DP   Module ", arr => [] },
                           "DC" => { title => "DP   CPU    ", arr => [] } } },
    "DU" => { "Left"  => { "DB" => { title => "DU Backlight", arr => [] },
                           "DL" => { title => "DU AMLCD    ", arr => [] },
                           "DH" => { title => "DU Heater   ", arr => [] },
                           "DO" => { title => "DU I/O Board", arr => [] },
                           "DD" => { title => "DU DICCA    ", arr => [] } },
              "Right" => { "DB" => { title => "DU Backlight", arr => [] },
                           "DL" => { title => "DU AMLCD    ", arr => [] },
                           "DD" => { title => "DU DICCA    ", arr => [] } } }
);

GetOptions("help|?"      => \$help,
           "file=s"      => \$fileList,
           "debug"       => \$debugInfo,
           "noplot"      => \$noPlot,
           "directory=s" => \$directory,
           "summary=s"   => \$summaryFile,
           "verbose"     => \$verbose,
           "man"         => \$man) or pod2usage(2);
pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;

# I want to be able to add some number of days to
# a date like Date::Calc::Add_Delta_Days(), but
# without anything more than the standard Perl 5.8.0
# distribution, since that is what we have for JSF.
sub add_delta_days {
    my ($month, $day, $year, $delta) = @_;
    my $thisTM = timelocal(0, 0, 0, $day, $month - 1, $year - 1900);
    my $tm = localtime($thisTM + $delta * 24 * 60 * 60);
    return ($tm->mon + 1, $tm->mday, $tm->year + 1900);
}

sub countMeasurements {
    my $count = 0;
    print "Counting Measurements\n" if $verbose;
    for my $lru (keys %temperatureMeasurements) {
        my $lruValue = $temperatureMeasurements{$lru};
        $count += sum(map { scalar keys %{ $lruValue->{$_} } } (keys %$lruValue));
    }
    print "Counting Measurements, count is $count\n" if $verbose;
    return $count;
}

sub formatLR { # Format Left and Right to have same string length
    return substr($_[0] . "," . (" " x 6), 0, 6);
}

sub formatLRSpace { # Format Left and Right to have same string length
    return substr($_[0] . (" " x 6), 0, 6);
}

sub csvCommaPos {
    my ( $leftRight, $search ) = @_;
    my $count = 1;
    my $thisCount = 100;

    for my $lru (reverse sort (keys %temperatureMeasurements)) {
        print "--" . $lru . "--\n" if $verbose;
        my $lruValue = $temperatureMeasurements{$lru};
        for my $side (sort (keys %$lruValue)) {
            print "----" . $side . "--\n" if $verbose;
            for my $meas (@tempMeasOrderedList) {
                if (defined($lruValue->{$side}->{$meas})) {
                    print "------" . $meas . "--\n" if $verbose;
                    if (($leftRight eq $side) && ($meas eq $search)) {
                        print "Found $leftRight $meas at $count, lru $lru, side $side, meas $meas\n" if $verbose;
                        $thisCount = $count;
                    }
                    $count++;
                }
            }
        }
    }
    return $thisCount;
}

sub generateTitles {
    my $title = "Time,";
    for my $lru (reverse sort (keys %temperatureMeasurements)) {
        my $lruValue = $temperatureMeasurements{$lru};
        for my $side (sort (keys %$lruValue)) {
            for my $meas (@tempMeasOrderedList) {
                $title .= $side . " " . $meas . "," if (defined($lruValue->{$side}->{$meas}));
            }
        }
    }
    $title .= "Chamber,Left A Amps,Left B Amps,Right A Amps,Right B Amps, Left A Volts, Left B Volts, Right A Volts, Right B Volts, Left A watts, Left B watts, Right A watts, Right B watts\n";
    return $title;
}

sub getTempArrByName { # Get Temperature Array By Name
    my ( $leftRight, $name ) = @_;
    my $results;

    for my $lru (reverse sort (keys %temperatureMeasurements)) {
        my $sideValue = $temperatureMeasurements{$lru}->{$leftRight};
        $results = $sideValue->{$name}->{arr} if (defined($sideValue->{$name}));
    }
    return $results;
}

sub getListOfTempSides { # Get a List of the Temperature Sides
    my ( $lru ) = @_;
    return (keys %{ $temperatureMeasurements{$lru} });
}

sub getListOfTempNames { # Get a List of the Temperature Names
    my ( $lru, $leftRight ) = @_;
    return (keys %{ $temperatureMeasurements{$lru}{$leftRight} });
}

sub getTitleByName { # Get Temperature Title String By Name
    my ( $leftRight, $name ) = @_;
    my $results;

    for my $lru (reverse sort (keys %temperatureMeasurements)) {
        my $sideValue = $temperatureMeasurements{$lru}->{$leftRight};
        $results = $sideValue->{$name}->{title} if (defined($sideValue->{$name}));
    }
    return $results;
}

sub printTemp {
    my ( $leftRight, $thisMeas, $thisTime, $thisTemp ) = @_;
    print "printTemp( $leftRight, $thisMeas, $thisTime, $thisTemp )\n" if $verbose;
    return $thisTime . "," x csvCommaPos($leftRight, $thisMeas) . $thisTemp . "\n";
}

sub procTemp {
    my ( $leftRight, $name, $thisTime, $thisTemperature ) = @_;
    my $results;

    print "procTemp( $leftRight, $name, $thisTime, $thisTemperature )\n" if $verbose;
    my $thisArr = getTempArrByName($leftRight, $name);
    if (defined($thisArr)) {
        $results = printTemp($leftRight, $name, $thisTime, $thisTemperature);
        push(@$thisArr, $thisTemperature);
    }
    return $results;
}

sub maxInt { # I think int(undef) should return undef, not zero.
    my $array = $_[0];
    my $ret;
    $ret = int(max(@$array)) if ((defined($array)) && (defined(max(@$array))));
    return $ret;
}

sub largeTempDiff { # large temperature diff is larger that 25C
    my ( $thisArray, $thatArray ) = @_;
    my $ret;
    if ((defined(maxInt($thisArray))) && (defined(maxInt($thatArray)))) {
        $ret = 1 if (abs(maxInt($thisArray) - maxInt($thatArray)) > 25);
    }
    return $ret;
}

sub printArrayTemperatureInfo {
    my ( $refToArr, $fmt ) = @_;
    my @arr = sort { $a <=> $b } @$refToArr;
    if (@arr != 0) {
        printf(" Max : " . $fmt, $arr[$#arr]);
        printf(", Min : " . $fmt, $arr[0]);
        printf(", Avg : " . $fmt, sum(@arr) / @arr);
        printf(", Mean : " . $fmt, $arr[int(@arr / 2)]);
    }
}

sub printMaxTemp {
    my ( $label, $fmt, $units, $refToArr, $failureTemp, $warnTemp, $secondWarnTemp, $temperatureToReach ) = @_;
    my $thisTemp = maxInt($refToArr);

    if (defined($thisTemp)) {
        print $label;
        printArrayTemperatureInfo($refToArr, $fmt);
        if ((defined($failureTemp)) && ($thisTemp >= $failureTemp)) {
            print " <<--- Over Failure Temperature";
        }
        elsif ((defined($warnTemp)) && ($thisTemp >= $warnTemp)) {
            print " <<--- Over Warning Temperature";
        }
        elsif ((defined($secondWarnTemp)) && ($thisTemp > $secondWarnTemp)) {
            print " <<--- Over " . $secondWarnTemp . $units;
        }
        elsif ((defined($temperatureToReach)) && ($thisTemp < $temperatureToReach)) {
            print " <<--- Did not reach " . $temperatureToReach . $units;
        }
        print "\n";
    }
}

sub monthToNum {
    my %mon2num = qw(
      jan 1  feb 2  mar 3  apr 4  may 5  jun 6
      jul 7  aug 8  sep 9  oct 10 nov 11 dec 12
    );
    return $mon2num{ lc substr($_[0], 0, 3) } + 0;
}

sub pushOntoErrorList {
    my ( $refToArr, $refToCountOfRealErrors, $msg ) = @_;

    if (defined($refToArr)) {
        push(@$refToArr, $msg);
        $$refToCountOfRealErrors += 1;
    }
}

sub parseNetworkDataRates {
    my $thisLine = $_[0];
    my @errs = ();

    if ($thisLine =~ /(F[CW]) - SR:\s*(\d+)([pf]) TxM:\s*(\d+)([pf]) TxB:\s*(\d+)([pf]) RxM:\s*(\d+)([pf]) RxB:\s*(\d+)([pf]) (CRC|Par):\s*(\d+)([pf]) (Dis|Bus):\s*(\d+)([pf]) TxE:\s*(\d+)([pf]) RxE:\s*(\d+)([pf])/) {
        @_ = $thisLine =~ /(F[CW]) - SR:\s*(\d+)([pf]) TxM:\s*(\d+)([pf]) TxB:\s*(\d+)([pf]) RxM:\s*(\d+)([pf]) RxB:\s*(\d+)([pf]) (CRC|Par):\s*(\d+)([pf]) (Dis|Bus):\s*(\d+)([pf]) TxE:\s*(\d+)([pf]) RxE:\s*(\d+)([pf])/;
        my ( $shortName, $syncRate, $syncRatePF, $transMsgs, $transMsgsPF,
             $transBytes, $transBytesPF, $recMsgs, $recMsgsPF, $recBytes,
             $recBytesPF, $checkType, $checkFails, $checkFailsPF, $otherType,
             $otherFails, $otherFailsPF, $transErrors, $transErrorsPF,
             $recErrors, $recErrorsPF ) = @_;
        my $netType = ($shortName eq "FC") ? "Fibre Channel" : "FireWire";
        push(@errs, $netType . " failed sync rate at " . $syncRate . " Hz") if ($syncRatePF eq "f");
        push(@errs, $netType . " failed transmit message rate at " . $transMsgs . " msgs/sec") if ($transMsgsPF eq "f");
        push(@errs, $netType . " failed transmit bytes rate at " . $transBytes . " bytes/sec") if ($transBytesPF eq "f");
        push(@errs, $netType . " failed receive message rate at " . $recMsgs . " msgs/sec") if ($recMsgsPF eq "f");
        push(@errs, $netType . " failed receive bytes rate at " . $recBytes . " bytes/sec") if ($recBytesPF eq "f");
        push(@errs, $netType . " failed " . ($checkType eq "CRC" ? "CRC" : "Parity") . ", count " . $checkFails) if ($checkFailsPF eq "f");
        push(@errs, $netType . " failed " . ($otherType eq "Dis" ? "Discarded Packets" : "Bus Resets") . ", count " . $otherFails) if ($otherFailsPF eq "f");
        push(@errs, $netType . " failed, transmition errors count " . $transErrors) if ($transErrorsPF eq "f");
        push(@errs, $netType . " failed receive errors count " . $recErrors) if ($recErrorsPF eq "f");
    } else {
        push(@errs, "Network Data Rate Line did not parse correctly.");
    }
    return @errs;
}

sub prepErrString {
    my ( $thisTime, $leftRight, $title, $specific ) = @_;
        $powerCycleErrors{$powerCycleKey}{$leftRight} = $specific;
        my $specificEdit = $specific;
        $specificEdit =~ s/at \d* msgs.sec//;
        $specificErrorList{$specificEdit}{$powerCycleKey} = 1;
        # XXX XXX XXX XXX XXX XXX
        #if ($specific =~ /(Video|Disabled|VP Config)/) {
        #}
        # XXX XXX XXX XXX XXX XXX
    return " At " . $thisTime . ", " . formatLR($leftRight) . " " . $title . " -- " . $specific;
}

sub procErrWords {
    my ( $thisTime, $leftRight, $word, $bits, $title, $decode ) = @_;
    my @errs = ();

    # my $errTime = "At " . $thisTime . ", " . formatLR($leftRight) . $title . $word . " value 0x" . $bits;
    my $errTitle = sprintf("%s %02d value 0x%s", $title, $word, $bits);
    if (hex($bits) == 0) {
        push(@errs, prepErrString($thisTime, $leftRight, $errTitle, "Flagged as failure with no bits set"));
    } else {
        map { push(@errs, prepErrString($thisTime, $leftRight, $errTitle, apply { s/ 0x%[Xx]// } $_ )) } &$decode($word - 1, hex($bits));
    }
    return @errs;
}

sub gpErrors {
    return procErrWords(@_, "General OTP error Word ", \&OtpFaults::get_errors_from_fault_word);
}

sub euPostErrors {
    return procErrWords(@_, "EU POST     error Word ", \&EuPostFaults::get_errors_from_eu_post);
}

sub euCbitErrors {
    return procErrWords(@_, "EU CBIT     error Word ", \&EuCbitFaults::get_errors_from_eu_cbit);
}

sub dpPostErrors {
    return procErrWords(@_, "DP POST     error Word ", \&DpPostFaults::get_errors_from_dp_post);
}

sub dpCbitErrors {
    return procErrWords(@_, "DP CBIT     error Word ", \&DpCbitFaults::get_errors_from_dp_cbit);
}

sub duErrors {
    return procErrWords(@_, "DU BIT      error Word ", \&DuFaults::get_errors_from_du);
}

sub procErrWord {
    my ( $thisTime, $leftRight, $thisLine, $thisMatch, $thisSub, 
         $startGP, $subtract, $pieces, $errorList ) = @_;

    if ($thisLine =~ /$thisMatch/) {
        my $gp = $startGP;
        while ((defined($$pieces[$gp])) && ($$pieces[$gp++] =~ /([0-9a-fA-F]{8})([pf])/)) {
            my $word = $gp - $subtract;
            push(@$errorList, &$thisSub($thisTime, $leftRight, $word, $1)) if ($2 eq "f");
        }
    }
}

sub maxTempDiff {
    my ($thisArr, $thatArr, $thisDesc, $thatDesc) = @_;

    if ((defined(maxInt($thisArr))) && (defined(maxInt($thatArr)))) {
        print "Max Diff between " . $thisDesc . " and " . $thatDesc . " : " . abs((maxInt($thisArr) - maxInt($thatArr)));
        print " <<--- Large Difference" if (largeTempDiff($thisArr, $thatArr));
        print "\n";
    }
}

sub parseFile {
    my $fileName             = $_[0];
    my @pieces               = ();
    my $thisLine             = '';
    my $modeLine             = '';
    my $unitLine             = '';
    my $dateLine             = '';
    my $operatorLine         = '';
    my $thisOperatorId       = 0;
    my $coldCurrentTemp      = -5;
    my $hotCurrentTemp       = 35;
    my $thisTime             = '';

    my $cycleNumber          = 0;
    my $cycleFailures        = 0;
    my $testNumber           = 0;
    my $testFailures         = 0;
    my $lastCycleNumber      = 0;
    my $lastCycleFailures    = 0;
    my $lastTestNumber       = 0;
    my $lastTestFailures     = 0;
    my $savedCycleNumber     = 0;
    my $savedCycleFailures   = 0;
    my $savedTestNumber      = 0;
    my $savedTestFailures    = 0;
    my $totalCycleNumber     = 0;
    my $totalCycleFailures   = 0;
    my $totalTestNumber      = 0;
    my $totalTestFailures    = 0;
    my $totalPowerCycles     = 0;

    my $numberOfErrorClears  = 0;
    my $serialFailures       = 0;
    my $lastTime             = '';
    my $thisHour             = 0;
    my $lastHour             = 0;
    my $finishLastCycle      = 0;
    my $powerCycle           = 1;
    my $foundFirstReport     = 0;
    my $thisTemperature      = 0;
    my $thisChamberTemperature = undef;
    my $lastLeftBCurrent     = undef; # to synchronize the occurrance of left B and right B current
    my $lastLeftLVPSTemp     = undef; # keep track of what we think the LVPS temperature currently is
    my $lastRightLVPSTemp    = undef; # or our best guess being the last measurement. Maybe should be alpha beta filter.
    my $thisName             = "";
    my $thisPowerSupply      = "";
    my $powerCycleFirstCycle = 0;
    my $fileLineCount        = 1;
    my $leftRight            = "";
    my $measurementCount     = countMeasurements() + 1; # Add one for the time column
    my $maxChamberTemp;

    my @arrLeftACurrent = ();
    my @arrLeftBCurrent = ();
    my @arrLeftBTempAndCurrent = ();
    my @arrLeftAHotCurrent = ();
    my @arrLeftBHotCurrent = ();
    my @arrLeftAColdCurrent = ();
    my @arrLeftBColdCurrent = ();
    my @arrLeftAVoltage = ();
    my @arrLeftBVoltage = ();
    my @arrLeftAPower = ();
    my @arrLeftBPower = ();

    my @arrRightACurrent = ();
    my @arrRightBCurrent = ();
    my @arrRightBTempAndCurrent = ();
    my @arrRightAHotCurrent = ();
    my @arrRightBHotCurrent = ();
    my @arrRightAColdCurrent = ();
    my @arrRightBColdCurrent = ();
    my @arrRightAVoltage = ();
    my @arrRightBVoltage = ();
    my @arrRightAPower = ();
    my @arrRightBPower = ();
    my @arrChamberTemp = ();
    my @arrGDPlotTime = ();
    my @arrGDPlotLeftBCurrent = ();
    my @arrGDPlotRightBCurrent = ();
    my @errorList = ();
    my @theseErrors = ();

    my %leftVersions = ();
    my %rightVersions = ();

    my $Month             = 8;
    my $Day               = 14;
    my $Year              = 2010;


    my $thisDate = $Month . "/" . $Day . "/" . $Year;
    my $df = "$directory" . "/" . "$fileName";
    my $outFile = $df . '.csv';
    my $curFile = $df . '.current.csv';
    my $temFile = $df . '.tempVsCurrent.csv';
    open FILE, $df or die "Could not open input file $df : $!";
    open OUTF, '>' . $outFile or die "Could not open output  file $outFile : $!";
    open CURF, '>' . $curFile or die "Could not open current file $curFile: $!";
    open TEMF, '>' . $temFile or die "Could not open temp vs cur file $temFile: $!";

    my $shortRunName = "Unknown";
    if ($fileName =~ /(\d\d\d\d) (\d\d\d\d)-(\d\d)-(\d\d) (\d\d)\.(\d\d) JSF EU ESS.txt/) {
        $shortRunName = $1 . " (" . $3 . "/" . $4 . " " . $5 . "." . $6 . ")";
    }
    %powerCycleErrors = ();
    %specificErrorList = ();

    while (<FILE>) {
        if (defined($_)) {
            chomp($_);
            @pieces = split(' ', $_);
            $thisLine    = $_;
            if ($thisLine =~ /MTE RS-422 Errors/) {
                $serialFailures++;
            }
            if ($thisLine =~ /Power Cycle -/) {
                $lastLeftBCurrent = undef; # undefine state variables that should not cross power cycles
                $powerCycle = 1;
                $totalPowerCycles++;
                # new forms of the ESS log will have the full date and time, the chamber interval
                # and chamber temperature on the Power Cycle line. We can use this to stash away
                # the errors we are interested in.
                # Power Cycle - 6/17/2015 9:59 PM, Interval 1, Chamber Temperature 25
                if ($thisLine =~ /Power Cycle - (\d+\/\d+\/20\d\d \d+:\d\d [AP]M)/) {
                    $powerCycleKey = $1;
                    push(@powerCycleList, $powerCycleKey);
                } else {
                    print "ACK!!!!!!!!!!!! - $thisLine\n";
                    $powerCycleKey = undef;
                }
            }
            if ($thisLine =~ /^MTE PC Name: /) {
                $MTE = $pieces[3];
            }
            if ($thisLine =~ /^MODE: /) {
                $ESSMode = $pieces[1];
                $modeLine = $thisLine;
            }
            if ($thisLine =~ /^UNIT S.N: /) {
                $EU = "EU #" . $pieces[2];
                $unitLine = $thisLine;
            }
            if ($thisLine =~ /^DATE: /) {
                $Day   = $pieces[1];
                $Month = &monthToNum($pieces[2]);
                $Year  = $pieces[3];
                $thisDate = $Month . "/" . $Day . "/" . $Year;
                $dateLine = $thisLine;
            }
            if ($thisLine =~ /^OPERATOR ID: /) {
                $thisOperatorId = $pieces[2] + 0;
                $operatorLine = $thisLine;
            }

# We want to find the lines that indicate the test we are on
            if ((length($thisLine) > 36) && (defined(substr($thisLine, 37, 6)))) {
                if ($thisLine =~ /${cycleCountRegEx}\s*(Left)\s+/) { # Left header line
# When we find a Left line, we need to finish processing the
# previous test cycle
                    $leftRight = "Left";
                    $cycleNumber       = $1;
                    $cycleFailures     = $2;
                    ($cycleNumber =~ /$RE{num}{int}/) or die("Did not match correctly on the anchor Left line");
                    ($cycleFailures =~ /$RE{num}{int}/) or die("Did not match correctly on the anchor Left line");
                    $thisTime          = $pieces[2];
                    # there is always the chance they hit the Clear button
                    # we have to keep track of all the previous counts
                    if ($cycleNumber < $lastCycleNumber) {
                        # they have pressed the clear button, save what we
                        # have. We add it in, since they may press clear
                        # multiple times
                        $savedCycleNumber += $lastCycleNumber;
                        $savedCycleFailures += $lastCycleFailures;
                        $savedTestNumber += $lastTestNumber;
                        $savedTestFailures += $lastTestFailures;
                        $numberOfErrorClears++;
                    }
                    $lastCycleNumber   = $cycleNumber;
                    $lastCycleFailures = $cycleFailures;
                    if (!$foundFirstReport) {
                        $lastTime = $thisTime;
                    }
                    $thisHour = $thisTime;
                    $thisHour =~ s/:.*//;
                    $lastHour = $lastTime;
                    $lastHour =~ s/:.*//;
                    if ($lastHour > $thisHour) {
                        ($Month, $Day, $Year) = add_delta_days($Month, $Day, $Year, 1);
                        $thisDate = $Month . "/" . $Day . "/" . $Year;
                    }
                    $lastTime = $thisTime;
                    # Find the Power Supply status, this should be a string of
                    # four characters, either "p" or "f" for pass or fail older
                    # logs will have them in upper case, newer logs will have
                    # them in lower case
                    if ($thisLine =~ /${powerSupplyRegEx}(\w\w)(...)([pf])\s\w\w${etiValueRegEx}[pf]\s${discreteInRegEx}\/${discreteInRegEx}[pf]\s${discreteOutRegEx}\/${discreteOutRegEx}[pf]\s(${voltageRegEx})\/(${voltageRegEx})\s([pf])/) {
                        $leftRight = $1;
                        $thisPowerSupply = $2;
                        $thisName = $3;
                        $thisTemperature = $4 + 0;
                        my $thisTemperatureFlag = $5;
                        my $thisBezVolIn = $6 + 0.0;
                        my $thisBezVolMeas = $7 + 0.0;
                        my $thisBezVolFlag = $8;
                        if ($thisBezVolFlag ne 'p') {
                            push(@errorList, prepErrString($thisTime, $leftRight, "Bezel Voltage Brightness Test", "Bezel Brightness Input Voltage Failed, expected " . sprintf("%6.3f", $thisBezVolIn) . ", got " . sprintf("%6.3f", $thisBezVolMeas)));
                        }

                        if ($foundFirstReport != 1) {
                            print OUTF generateTitles();
                        }
                        if ($thisTemperatureFlag eq 'p') {
                            my $ptRes = procTemp($leftRight, $thisName, $thisTime, $thisTemperature);
                            print OUTF $ptRes if (defined($ptRes));
                            if ($thisName eq "PS") {
                                $lastLeftLVPSTemp = $thisTemperature;
                            }
                        }
                        if ($thisPowerSupply =~ /f/) {
                            push(@errorList, "At " . $thisTime . ", " . $leftRight . ", Power Supply Failure Flagged - " . $thisPowerSupply);
                        }
                    }
                    if ($thisLine =~ /\d\d\s+([0-9\-\.]+) Left  /) {
                        $leftRight = "Left";
                        $thisTemperature = $1 + 0;
                        print OUTF $thisTime . "," x $measurementCount . $thisTemperature . "\n";
                        push(@arrChamberTemp, $thisTemperature);
                        $thisChamberTemperature = $thisTemperature;
                    }
                    elsif ($thisLine =~ /\d\d\s+Amb Left  /) {
                        $leftRight = "Left";
                        $maxChamberTemp = "Ambient";
                        print OUTF "$thisTime\n";
                        $thisChamberTemperature = undef;
                    }
                    if ($powerCycle) {
                        $powerCycleFirstCycle = 1;
                        $powerCycle = 0;
                        if (defined($thisChamberTemperature)) {
                            push(@errorList, "\n===== Power On at " . $thisDate . ", " . $thisTime . ", Chamber Temperature " . sprintf("%5.1f", $thisChamberTemperature) . "C");
                        } else {
                            push(@errorList, "\n===== Power On at " . $thisDate . ", " . $thisTime);
                        }
                    } else {
                        $powerCycleFirstCycle = 0;
                    }
                    if ($thisLine =~ / ([AB]) (\d+\.\d+) (\d+\.\d+) ([A-Z][A-Z].)(........)([pf])/) {
                        $thisName = $1;
                        my $thisCurrent = $2 + 0;
                        my $thisVoltage = $3 + 0;
                        if ($6 eq 'p') {
                            $leftVersions{$4} = $5;
                        }
                        if ($foundFirstReport != 1) {
                            print CURF "Time,Left A amps,Left B amps,Right A amps, Right B amps, Left A volts, Left B volts, Right A volts, Left A watts, Left B watts, Right A watts, Right B watts\n";
                            print TEMF "Temperature, Left B amps, Right B amps, Left B Volts, Right B Volts, Left B watts, Right B watts\n";
                        }
                        if ($thisName eq "A") {
                            print OUTF $thisTime . "," x ($measurementCount + 1) . $thisCurrent . ",,,," . $thisVoltage . ",,,," . ($thisVoltage * $thisCurrent) . "\n";
                            print CURF "$thisTime,$thisCurrent,,,\n";
                            push(@arrLeftACurrent, $thisCurrent);
                            push(@arrLeftAVoltage, $thisVoltage);
                            push(@arrLeftAPower, ($thisVoltage * $thisCurrent));
                            if (defined($thisChamberTemperature)) {
                                push(@arrLeftAColdCurrent, $thisCurrent) if ($thisChamberTemperature < $coldCurrentTemp);
                                push(@arrLeftAHotCurrent, $thisCurrent) if ($thisChamberTemperature > $hotCurrentTemp);
                            }
                        }
                        if ($thisName eq "B") {
                            print OUTF $thisTime . "," x ($measurementCount + 2) . $thisCurrent . ",,,," . $thisVoltage . ",,,," . ($thisVoltage * $thisCurrent) . "\n";
                            print CURF "$thisTime,,$thisCurrent,,\n";
                            push(@arrLeftBCurrent, $thisCurrent);
                            push(@arrLeftBVoltage, $thisVoltage);
                            my $thisPower = $thisVoltage * $thisCurrent;
                            push(@arrLeftBPower, $thisPower);
                            $lastLeftBCurrent = $thisCurrent;
                            if (defined($lastLeftLVPSTemp)) {
                                print TEMF "$lastLeftLVPSTemp, $thisCurrent,, $thisVoltage,, $thisPower,\n";
                                push(@arrLeftBTempAndCurrent, [ $lastLeftLVPSTemp, $thisCurrent ]);
                            }
                            if (defined($thisChamberTemperature)) {
                                push(@arrLeftBColdCurrent, $thisCurrent) if ($thisChamberTemperature < $coldCurrentTemp);
                                push(@arrLeftBHotCurrent, $thisCurrent) if ($thisChamberTemperature > $hotCurrentTemp);
                            }
                        }
                    }
                    $foundFirstReport  = 1;
                    $totalPowerCycles++ if ($totalPowerCycles == 0);
                }
                elsif ($thisLine =~ /${cycleCountRegEx}\s*(Right)\s+/) { # Right header line
                    $leftRight = "Right";
                    $testNumber    = $pieces[0];
                    $testFailures  = $pieces[1];
                    $lastTestNumber = $testNumber;
                    $lastTestFailures = $testFailures;
                    if ($thisLine =~ /${powerSupplyRegEx}(\w\w)(...)p/) {
                        $leftRight = $1;
                        $thisPowerSupply = $2;
                        $thisName = $3;
                        $thisTemperature = $4 + 0;

                        my $ptRes = procTemp($leftRight, $thisName, $thisTime, $thisTemperature);
                        print OUTF $ptRes if (defined($ptRes));
                        if ($thisName eq "PS") {
                            $lastRightLVPSTemp = $thisTemperature;
                        }
                        if ($thisPowerSupply =~ /f/) {
                            push(@errorList, "At " . $thisTime . ", " . $leftRight . ", Power Supply Failure Flagged - " . $thisPowerSupply);
                        }
                    }
                    if ($thisLine =~ / ([AB]) (\d+\.\d+) (\d+\.\d+) ([A-Z][A-Z].)(........)([pf])/) {
                        $thisName = $1;
                        my $thisCurrent = $2 + 0;
                        my $thisVoltage = $3 + 0;
                        if ($6 eq 'p') {
                            $rightVersions{$4} = $5;
                        }
                        if ($thisName eq "A") {
                            print OUTF $thisTime . "," x ($measurementCount + 3) . $thisCurrent . ",,,," . $thisVoltage . ",,,," . ($thisVoltage * $thisCurrent) . "\n";
                            print CURF "$thisTime,,,$thisCurrent,\n";
                            push(@arrRightACurrent, $thisCurrent);
                            push(@arrRightAVoltage, $thisVoltage);
                            push(@arrRightAPower, ($thisVoltage * $thisCurrent));
                            if (defined($thisChamberTemperature)) {
                                push(@arrRightAColdCurrent, $thisCurrent) if ($thisChamberTemperature < $coldCurrentTemp);
                                push(@arrRightAHotCurrent, $thisCurrent) if ($thisChamberTemperature > $hotCurrentTemp);
                            }
                        }
                        if ($thisName eq "B") {
                            print OUTF $thisTime . "," x ($measurementCount + 4) . $thisCurrent . ",,,," . $thisVoltage . ",,,," . ($thisVoltage * $thisCurrent) . "\n";
                            print CURF "$thisTime,,,,$thisCurrent\n";
                            push(@arrRightBCurrent, $thisCurrent);
                            push(@arrRightBVoltage, $thisVoltage);
                            my $thisPower = $thisVoltage * $thisCurrent;
                            push(@arrRightBPower, $thisPower);
                            push(@arrGDPlotTime, $thisTime);
                            push(@arrGDPlotLeftBCurrent, (!defined$lastLeftBCurrent) ? 0 : $lastLeftBCurrent);
                            push(@arrGDPlotRightBCurrent, $thisCurrent);
                            if (defined($lastRightLVPSTemp)) {
                                print TEMF "$lastRightLVPSTemp,, $thisCurrent,, $thisVoltage,, $thisPower\n";
                                push(@arrRightBTempAndCurrent, [ $lastRightLVPSTemp, $thisCurrent ]);
                            }
                            if (defined($thisChamberTemperature)) {
                                push(@arrRightBColdCurrent, $thisCurrent) if ($thisChamberTemperature < $coldCurrentTemp);
                                push(@arrRightBHotCurrent, $thisCurrent) if ($thisChamberTemperature > $hotCurrentTemp);
                            }
                        }
                    }
                }
                if ($thisLine =~ /${powerSupplyRegEx}\w\w...[pf]\s\w\w${etiValueRegEx}[pf]\s(${discreteInRegEx})\/(${discreteInRegEx})([pf])\s${discreteOutRegEx}\/${discreteOutRegEx}[pf]/) {
                    $leftRight = $1;
                    $thisPowerSupply = $2;
                    my $thisDiscreteInSet = $3;
                    my $thisDiscreteInGot = $4;
                    my $thisDiscreteInFlag = $5;
                    if ((defined($thisDiscreteInFlag)) && ($thisDiscreteInFlag ne 'p')) {
                        push(@errorList, prepErrString($thisTime, $leftRight, "Discrete Input error", "Discrete Input Test Failed, set " . $thisDiscreteInSet . ", got " . $thisDiscreteInGot));

                    }
                }
                if ($thisLine =~ /${powerSupplyRegEx}\w\w...[pf]\s\w\w${etiValueRegEx}[pf]\s(${discreteInRegEx})\/(${discreteInRegEx})([pf])\s${discreteOutRegEx}\/${discreteOutRegEx}[pf]\s([A-Z][A-Z\s]*[A-Z])\s*([pf])/) {
                    $leftRight = $1;
                    $thisPowerSupply = $2;
                    my $thisDiscreteInSet = $3;
                    my $thisDiscreteInGot = $4;
                    my $thisDiscreteInFlag = $5;
                    my $hmd = $6;
                    my $hmdFlag = $7;
                    if ((defined($hmdFlag)) && ($hmdFlag ne 'p')) {
                        push(@errorList, prepErrString($thisTime, $leftRight, "HMD           errors", "HMD Failed for test " . $hmd));
                    }
                }
                if ($thisLine =~ /\s[pf]\s[ABCD][pf]\s[1234][AB][pf]\s[12][pf]\s(\d\d)([pf])\s/) {
                    my $vsyncFreq = $1;
                    my $vsyncFreqFlag = $2;
                    if ((defined($vsyncFreqFlag)) && ($vsyncFreqFlag ne 'p')) {
                        push(@errorList, prepErrString($thisTime, $leftRight, "VSync Freq    errors", "VSync Frequency " . $vsyncFreq . " Hz"));
                    }
                }
            }

            if ($foundFirstReport) {
                if ($thisLine =~ /${powerSupplyRegEx}[A-Z][A-Z].*[pf] G${wordsBitsRegEx}f [0-9]\.[0-9] /) {
                    $leftRight = $1;
                    push(@errorList, gpErrors($thisTime, $leftRight, $3, $4));
                }
                if ($thisLine =~ /${powerSupplyRegEx}[A-Z][A-Z].*[pf] P${wordsBitsRegEx}f [IGP]${wordsBitsRegEx}[pf] [0-9]\.[0-9] /) {
                    $leftRight = $1;
                    push(@errorList, euPostErrors($thisTime, $leftRight, $3, $4));
                }
                if ($thisLine =~ /${powerSupplyRegEx}[A-Z][A-Z].*[pf] C${wordsBitsRegEx}f [IGP]${wordsBitsRegEx}[pf] [0-9]\.[0-9] /) {
                    $leftRight = $1;
                    push(@errorList, euCbitErrors($thisTime, $leftRight, $3, $4));
                }
                if ($thisLine =~ /${powerSupplyRegEx}[A-Z][A-Z].*[pf] [CP]${wordsBitsRegEx}[pf] P${wordsBitsRegEx}f [0-9]\.[0-9] /) {
                    $leftRight = $1;
                    push(@errorList, dpPostErrors($thisTime, $leftRight, $5, $6));
                }
                if ($thisLine =~ /${powerSupplyRegEx}[A-Z][A-Z].*[pf] [CP]${wordsBitsRegEx}[pf] [IGP]${wordsBitsRegEx}[pf] [0-9]\.[0-9] .* [0-9a-fA-F]{2}[pf] (CL|CH|PB|IB)([0-9a-fA-F]{8})f [hH][pf]/) {
                    $leftRight = $1;
                    my $word = 0;
                    if (($7 eq "CL") || ($7 eq "PB") || ($7 eq "IB")) {
                        $word = 2;
                    } else {
                        $word = 1;
                    }
                    push(@errorList, duErrors($thisTime, $leftRight, $word, $8));
                }

                procErrWord($thisTime, $leftRight, $thisLine, "EU POST:",   \&euPostErrors,  2,  2, \@pieces, \@errorList);
                procErrWord($thisTime, $leftRight, $thisLine, "EU CBIT:",   \&euCbitErrors, 10, 10, \@pieces, \@errorList);
                procErrWord($thisTime, $leftRight, $thisLine, "GP: 1-10:",  \&gpErrors,      2,  2, \@pieces, \@errorList);
                procErrWord($thisTime, $leftRight, $thisLine, "GP: 11-16:", \&gpErrors,      2, -8, \@pieces, \@errorList);
                procErrWord($thisTime, $leftRight, $thisLine, "DP POST:",   \&dpPostErrors, 10, 10, \@pieces, \@errorList);
                procErrWord($thisTime, $leftRight, $thisLine, "DP IBIT:",   \&dpPostErrors,  2,  2, \@pieces, \@errorList);
                procErrWord($thisTime, $leftRight, $thisLine, "DP CBIT:",   \&dpCbitErrors,  8,  8, \@pieces, \@errorList);
                procErrWord($thisTime, $leftRight, $thisLine, "DU POST:",   \&duErrors,      2,  2, \@pieces, \@errorList);
                procErrWord($thisTime, $leftRight, $thisLine, "DU IBIT:",   \&duErrors,      5,  5, \@pieces, \@errorList);
                procErrWord($thisTime, $leftRight, $thisLine, "DU CBIT:",   \&duErrors,      8,  8, \@pieces, \@errorList);

                if ($thisLine =~ /(Left|Right)\s+[pf]{4}\s+\.\.\. Disabled \.\.\./) {
                    push(@errorList,     prepErrString($thisTime, $leftRight, "Node          errors", "Node is Disabled and Not Responding"));
                }
                if ($thisLine =~ />>> MTE RS-422 Errors/) {
                    push(@errorList,     prepErrString($thisTime, $leftRight, "RS-422        errors", $thisLine));
                }
                if ($thisLine =~ /^\s+FC - /) { # Fibre Channel Summary Line
                    @theseErrors = parseNetworkDataRates($thisLine);
                    if (@theseErrors) {
                        push(@errorList, prepErrString($thisTime, $leftRight, "Fibre Channel errors", $_)) for @theseErrors;
                    }
                }
                if ($thisLine =~ /^\s+FW - /) { # FireWire Summary Line
                    @theseErrors = parseNetworkDataRates($thisLine);
                    if (@theseErrors) {
                        push(@errorList, prepErrString($thisTime, $leftRight, "FireWire      errors", $_)) for @theseErrors;
                    }
                }
            }
        }
        $fileLineCount++;
    }
    close (FILE);
    close (OUTF);
    close (CURF);
    close (TEMF);

    print "$unitLine, $modeLine, $dateLine, $operatorLine,";
    if ((defined($maxChamberTemp)) && ($maxChamberTemp eq "Ambient")) {
        print " Ambient Run\n\n";
    } else {
        print " Chamber Run\n\n";
    }

    print "Versions\n";
    my @combinedKeys = uniq(keys %leftVersions, keys %rightVersions);

    for my $thisOne (sort @combinedKeys) {
        print $thisOne, " - ", (defined($leftVersions{$thisOne}) ? $leftVersions{$thisOne} : "        "), "    ",
              $thisOne, " - ", (defined($rightVersions{$thisOne}) ? $rightVersions{$thisOne} : "        "), "\n";
    }
    print "\n\n";

    print "Temperatures\n";
    printMaxTemp("Left  " . getTitleByName("Left",  "SM") . " Temp. ", "%3d", "C", getTempArrByName("Left",  "SM"), 97, 85, 100, undef);
    printMaxTemp("Left  " . getTitleByName("Left",  "SC") . " Temp. ", "%3d", "C", getTempArrByName("Left",  "SC"), 105, undef, 100, undef);
    printMaxTemp("Left  " . getTitleByName("Left",  "DM") . " Temp. ", "%3d", "C", getTempArrByName("Left",  "DM"), 97, 85, 100, undef);
    printMaxTemp("Left  " . getTitleByName("Left",  "DC") . " Temp. ", "%3d", "C", getTempArrByName("Left",  "DC"), 105, undef, 100, undef);
    printMaxTemp("Left  " . getTitleByName("Left",  "VP") . " Temp. ", "%3d", "C", getTempArrByName("Left",  "VP"), 97, 86, 100, undef);
    printMaxTemp("Left  " . getTitleByName("Left",  "IO") . " Temp. ", "%3d", "C", getTempArrByName("Left",  "IO"), 115, 100, 100, undef);
    printMaxTemp("Left  " . getTitleByName("Left",  "FC") . " Temp. ", "%3d", "C", getTempArrByName("Left",  "FC"), 87, 77, 100, undef);
    printMaxTemp("Left  " . getTitleByName("Left",  "PS") . " Temp. ", "%3d", "C", getTempArrByName("Left",  "PS"), 103, 91, 100, undef);
    printMaxTemp("Right " . getTitleByName("Right", "SM") . " Temp. ", "%3d", "C", getTempArrByName("Right", "SM"), 97, 85, 100, undef);
    printMaxTemp("Right " . getTitleByName("Right", "SC") . " Temp. ", "%3d", "C", getTempArrByName("Right", "SC"), 105, undef, 100, undef);
    printMaxTemp("Right " . getTitleByName("Right", "DM") . " Temp. ", "%3d", "C", getTempArrByName("Right", "DM"), 97, 85, 100, undef);
    printMaxTemp("Right " . getTitleByName("Right", "DC") . " Temp. ", "%3d", "C", getTempArrByName("Right", "DC"), 105, undef, 100, undef);
    printMaxTemp("Right " . getTitleByName("Right", "VP") . " Temp. ", "%3d", "C", getTempArrByName("Right", "VP"), 97, 86, 100, undef);
    printMaxTemp("Right " . getTitleByName("Right", "PS") . " Temp. ", "%3d", "C", getTempArrByName("Right", "PS"), 103, 91, 100, undef);
    print "\n";
    printMaxTemp("Left  " . getTitleByName("Left",  "DB") . " Temp. ", "%3d", "C", getTempArrByName("Left",  "DB"), 97, 85, 100, undef);
    printMaxTemp("Left  " . getTitleByName("Left",  "DL") . " Temp. ", "%3d", "C", getTempArrByName("Left",  "DL"), 97, 85, 100, undef);
    printMaxTemp("Left  " . getTitleByName("Left",  "DH") . " Temp. ", "%3d", "C", getTempArrByName("Left",  "DH"), 97, 85, 100, undef);
    printMaxTemp("Left  " . getTitleByName("Left",  "DO") . " Temp. ", "%3d", "C", getTempArrByName("Left",  "DO"), 97, 85, 100, undef);
    printMaxTemp("Left  " . getTitleByName("Left",  "DD") . " Temp. ", "%3d", "C", getTempArrByName("Left",  "DD"), 97, 85, 100, undef);
    printMaxTemp("Right " . getTitleByName("Right", "DB") . " Temp. ", "%3d", "C", getTempArrByName("Right", "DB"), 97, 85, 100, undef);
    printMaxTemp("Right " . getTitleByName("Right", "DL") . " Temp. ", "%3d", "C", getTempArrByName("Right", "DL"), 97, 85, 100, undef);
    printMaxTemp("Right " . getTitleByName("Right", "DD") . " Temp. ", "%3d", "C", getTempArrByName("Right", "DD"), 97, 85, 100, undef);
    print "\n";
    printMaxTemp("Chamber           Temp. ", "%3d", "C", \@arrChamberTemp, undef, undef, 100, 45);
    print "\n";

    print "Temperature Differences\n";
    for my $leftRight (sort (getListOfTempSides("EU"))) {
        for my $meas (getListOfTempNames("EU", $leftRight)) {
            if ($meas ne "SM") {
                maxTempDiff(getTempArrByName($leftRight, "SM"),
                            getTempArrByName($leftRight, $meas),
                            formatLRSpace($leftRight) . getTitleByName($leftRight, "SM"),
                            getTitleByName($leftRight, $meas));
            }
        }
        print "\n";
    }

    print "Power Use\n";
    printMaxTemp("Left  A Power  in Watts ", "%3d", " Watts", \@arrLeftAPower, undef, undef, 150, undef);
    printMaxTemp("Left  B Power  in Watts ", "%3d", " Watts", \@arrLeftBPower, undef, undef, 150, undef);
    printMaxTemp("Right A Power  in Watts ", "%3d", " Watts", \@arrRightAPower, undef, undef, 150, undef);
    printMaxTemp("Right B Power  in Watts ", "%3d", " Watts", \@arrRightBPower, undef, undef, 150, undef);
    printMaxTemp("Left  A Current in Amps ", "%3.1f", " Amps", \@arrLeftACurrent, undef, undef, 6, undef);
    printMaxTemp("Left  B Current in Amps ", "%3.1f", " Amps", \@arrLeftBCurrent, undef, undef, 6, undef);
    printMaxTemp("Right A Current in Amps ", "%3.1f", " Amps", \@arrRightACurrent, undef, undef, 6, undef);
    printMaxTemp("Right B Current in Amps ", "%3.1f", " Amps", \@arrRightBCurrent, undef, undef, 6, undef);
    print "\n";
    printMaxTemp("Left  A Hot   Curr Amps ", "%3.1f", " Amps", \@arrLeftAHotCurrent, undef, undef, 6, undef);
    printMaxTemp("Left  B Hot   Curr Amps ", "%3.1f", " Amps", \@arrLeftBHotCurrent, undef, undef, 6, undef);
    printMaxTemp("Right A Hot   Curr Amps ", "%3.1f", " Amps", \@arrRightAHotCurrent, undef, undef, 6, undef);
    printMaxTemp("Right B Hot   Curr Amps ", "%3.1f", " Amps", \@arrRightBHotCurrent, undef, undef, 6, undef);
    print "\n";
    printMaxTemp("Left  A Cold  Curr Amps ", "%3.1f", " Amps", \@arrLeftAColdCurrent, undef, undef, 6, undef);
    printMaxTemp("Left  B Cold  Curr Amps ", "%3.1f", " Amps", \@arrLeftBColdCurrent, undef, undef, 6, undef);
    printMaxTemp("Right A Cold  Curr Amps ", "%3.1f", " Amps", \@arrRightAColdCurrent, undef, undef, 6, undef);
    printMaxTemp("Right B Cold  Curr Amps ", "%3.1f", " Amps", \@arrRightBColdCurrent, undef, undef, 6, undef);
    print "\n";

    $totalCycleNumber = $cycleNumber + $savedCycleNumber;
    $totalCycleFailures = $cycleFailures + $savedCycleFailures;
    $totalTestNumber = $testNumber + $savedTestNumber;
    $totalTestFailures = $testFailures + $savedTestFailures;

    if (@errorList) {
        print "\nESS Log Summary:\n";
        print $_, "\n" for @errorList;
        print "\nNumber of Decoded Errors : ", true { /^\s+At\s/ } @errorList;
    }
    print "\n\n";

    if (! -e "$summaryFile") {
        # print the header line
        open SUMMARY, ">" . "$summaryFile" or die "Could not open summary file $summaryFile : $!";
        print SUMMARY "Unit & Run, Left SP Mod, Left SP CPU, Left DP Mod, Left DP CPU, Left VP Mod, Left IO Mod, Left FC Mod, Left LVPS, Right SP Mod, Right SP CPU, Right DP Mod, Right DP CPU, Right VP Mod, Right LVPS, Chamber, Left A amps, Left B amps, Right A amps, Right B amps, Power Cycles, Test Cycles, Cycle Failures, Tests, Test Failures, Serial Failures, Error Clears\n";
    } else {
        open SUMMARY, ">>" . "$summaryFile" or die "Could not open summary file $summaryFile : $!";
    }
    print SUMMARY $shortRunName . ",";
    print SUMMARY define(maxInt(getTempArrByName("Left",  "SM"))) . ",";
    print SUMMARY define(maxInt(getTempArrByName("Left",  "SC"))) . ",";
    print SUMMARY define(maxInt(getTempArrByName("Left",  "DM"))) . ",";
    print SUMMARY define(maxInt(getTempArrByName("Left",  "DC"))) . ",";
    print SUMMARY define(maxInt(getTempArrByName("Left",  "VP"))) . ",";
    print SUMMARY define(maxInt(getTempArrByName("Left",  "IO"))) . ",";
    print SUMMARY define(maxInt(getTempArrByName("Left",  "FC"))) . ",";
    print SUMMARY define(maxInt(getTempArrByName("Left",  "PS"))) . ",";
    print SUMMARY define(maxInt(getTempArrByName("Right", "SM"))) . ",";
    print SUMMARY define(maxInt(getTempArrByName("Right", "SC"))) . ",";
    print SUMMARY define(maxInt(getTempArrByName("Right", "DM"))) . ",";
    print SUMMARY define(maxInt(getTempArrByName("Right", "DC"))) . ",";
    print SUMMARY define(maxInt(getTempArrByName("Right", "VP"))) . ",";
    print SUMMARY define(maxInt(getTempArrByName("Right", "PS"))) . ",";
    print SUMMARY define(maxInt(\@arrChamberTemp)) . ",";
    print SUMMARY define(max(\@arrLeftACurrent)) . ",";
    print SUMMARY define(max(\@arrLeftBCurrent)) . ",";
    print SUMMARY define(max(\@arrRightACurrent)) . ",";
    print SUMMARY define(max(\@arrRightBCurrent)) . ",";
    print SUMMARY $totalPowerCycles . ",";
    print SUMMARY $totalCycleNumber . ",";
    print SUMMARY $totalCycleFailures . ",";
    print SUMMARY $totalTestNumber . ",";
    print SUMMARY $totalTestFailures . ",";
    print SUMMARY $serialFailures . ",";
    print SUMMARY $numberOfErrorClears . ",";
    print SUMMARY "\n";
    close(SUMMARY);

    print "Dump It ------------------------------\n" if $verbose;
    my $powerCycleWithFailureCount = 0;
    my $vpFile  = $df . '.vp.csv';
    open VPF,  '>' . $vpFile  or die "Could not open VP file $vpFile: $!";
    my %columns;
    for my $key (keys %powerCycleErrors) {
        $powerCycleWithFailureCount++;
        for my $lr (keys %{ $powerCycleErrors{$key} }) {
            print "$key - $lr - $powerCycleErrors{$key}{$lr}\n" if $verbose;
            $columns{"$lr $powerCycleErrors{$key}{$lr}"} = "$lr $powerCycleErrors{$key}{$lr}";
        }
    }
    print VPF "Power Cycle Count,Power Cycle Timestamp";
    for my $key (sort keys %columns) {
        print VPF ", $key";
    }
    print VPF "\n";
    # Occurrance, Left Video Input, Left Video Compression, Right Video Input, Right Video Compression
    # for each power on sequence
    my $powerCycleCount = 1;
    for my $key (@powerCycleList) { # Walk through the columns
        print VPF $powerCycleCount++ . "," . $key;
        for my $col (sort keys %columns) { # look for a match for this colum
            my $foundIt = undef;
            if (defined($powerCycleErrors{$key})) {
                for my $lr (keys %{ $powerCycleErrors{$key} }) {
                    if ($columns{$col} eq "$lr $powerCycleErrors{$key}{$lr}") {
                        $foundIt = 1;
                    }
                }
            }
            if ($foundIt) {
                print VPF ", $foundIt";
            } else {
                print VPF ", 0";
            }
        }
        print VPF "\n";
    }
    close(VPF);
    print "Dump It Done -------------------------\n" if $verbose;

    # For each error, find the percentage of power cycles they have failed on
    for my $key (keys %specificErrorList) {
        my $specificErrorCount = 0;
        for my $powerCycle (keys %{ $specificErrorList{$key} }) {
            $specificErrorCount++;
        }
        print substr($key . (" " x 50), 0, 50) . " failed on " . sprintf("%4d", $specificErrorCount) . " power cycles, or ", sprintf("%6.2f", ($specificErrorCount / $totalPowerCycles) * 100.0), "%\n";
    }

    print "\nSummary";
    print "\nTotal Number of Power Cycles                       : " . $totalPowerCycles;
    print "\nTotal Number of Power Cycles with Failures         : " . $powerCycleWithFailureCount++;
    print "\nPercentage   of Power Cycles with Failures         : " . ($powerCycleWithFailureCount / $totalPowerCycles) * 100.0;
    print "\nTotal Number of Test Cycles                        : " . $totalCycleNumber;
    print " <<--- No Test Cycles Executed" if ($totalCycleNumber == 0);
    print "\nTotal Number of Test Cycle Failures                : " . $totalCycleFailures;
    print " <<--- Cycle Failures" if ($totalCycleFailures != 0);
    print "\nTotal Number of Individual Tests                   : " . $totalTestNumber;
    print " <<--- No Tests Executed" if ($totalTestNumber == 0);
    print "\nTotal Number of Individual Failures                : " . $totalTestFailures;
    print " <<--- Test Failures" if ($totalTestFailures != 0);
    print "\nTotal Number of Serial Command Channel Failures    : " . $serialFailures;
    print " <<--- Serial Comm Failures" if ($serialFailures != 0);
    print "\nTotal Number of Times Errors Were Manually Cleared : " . $numberOfErrorClears;
    print "\n";
    if (($totalCycleNumber == 0) || ($totalCycleFailures != 0) || ($totalTestNumber == 0) || ($totalTestFailures != 0) || ($serialFailures != 0)) {
        print "\nThis test run was not a clean run.\n\n";
    }

    if (! $noPlot) { # plot the GD Graphs
        my @legend = ( 'Left B Current in Amps', 'Right B Current in Amps' );
        my $myGraph = GD::Graph::bars->new(800, 600);

        $myGraph->set(
            x_label => 'Time',
            y_label => 'Current in Amps',
            title => 'B Supply Current in Amps') or warn $myGraph->error;
        $myGraph->set('x_labels_vertical' => 1);
        $myGraph->set(x_label_skip => 50);
        $myGraph->set(correct_width => 0);
        $myGraph->set_legend(@legend);

        my @data = ();
        if ($debugInfo) {
            print "Size of arrGDPlotTime          : ", scalar(@arrGDPlotTime), "\n";
            print "Size of arrGDPlotLeftBCurrent  : ", scalar(@arrGDPlotLeftBCurrent), "\n";
            print "Size of arrGDPlotRightBCurrent : ", scalar(@arrGDPlotRightBCurrent), "\n";
        }
        push(@data, \@arrGDPlotTime);
        push(@data, \@arrGDPlotLeftBCurrent);
        push(@data, \@arrGDPlotRightBCurrent);
        my $myImage = $myGraph->plot(\@data) or die $myGraph->error;

        open PLOTFILE, '>' . "$directory" . "/" . "$fileName" . '.png' or die "Could not open output file : $!";
        binmode PLOTFILE;
        print PLOTFILE $myImage->png;
        close PLOTFILE;
    }
}

print "\n";
# if we passed a file containing the list of files use that
if ((defined($fileList)) && ($fileList ne '')) {
    open FILELIST, "$fileList" or die "Could not open the list of files $fileList : $!";
    while (<FILELIST>) {
        chomp;
        my $arg = $_;
        # glob each argument
        if ((defined($arg)) && ($arg ne "")) {
            my @list = bsd_glob($arg);
            for my $thisOne (@list) {
                if ((defined($thisOne)) && ($thisOne ne "")) {
                    if (-e ($directory . "/" . $thisOne)) {
                        print "Parsing ESS Log File : $thisOne\n\n";
                        &parseFile($thisOne);
                    }
                }
            }
        }
    }
    close(FILELIST);
} else {
    for my $arg (@ARGV) {
        if ((defined($arg)) && ($arg ne "")) {
            if ((defined($arg)) && ($arg ne "")) {
                if (-e ($directory . "/" . $arg)) {
                    print "\nParsing ESS Log File : $arg\n\n";
                    &parseFile($arg);
                }
            }
        }
    }
}

__END__

=head1 NAME

essTemperatuesToCSV.pl - crunch the temperature data from ESS logs into Excel CSV files

=head1 SYNOPSIS

essTemperaturesToCSV.pl [--file=list_of_files] files...

    Options:
      --help        brief help message
      --man         manual page
      --file        a file containing a list of files
      --noplot      do not plot any graphs
      --debug       print debugging information
      --directory   the directory to process the files in
      --summary     the file to put the summary line in
      --verbose     print more information about the processing of the logs

=head1 OPTIONS

=over 8

=item B<help>

Print a brief help message and exit

=item B<man>

Print the manual page and exit

=item B<file>

The file to get the list of files from.

=item B<noplot>

If set, do not plot any graphs, just a text based report.

=item B<debug>

Print debugging information.

=item B<directory>

The directory to process the files in.

=item B<summary>

The summary file to write the one line of results into.

=item B<verbose>

Print debug information about the processing of the logs.

=back

=head1 DESCRIPTION

This function crunches the logs from ESS runs into temperature data in an Excel CSV
spreadsheet.

=cut

