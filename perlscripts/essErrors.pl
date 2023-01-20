#! perl

use Getopt::Long;

use strict;
use warnings;

my $RunNumber         = 11;
my $ESSMode           = "EU";
my $PowerOnTime       = 10;
my $PowerOffTime      = 2;
my $MTE               = "MTE #3";
my $EU                = "EU 3004";
my $PowerSupplies     = "L-3";
my $CodeMajorVersion  = "QA OTP";
my $Month             = 5;
my $Day               = 25;
my $Year              = 2011;
my $thisDate          = '';
my $thisTime          = '';
my $lineInCycleReport = 0;
my $leftSideReport    = 0;

# Spreadsheet should be
# Test Goal, Run Number, ESS Mode, Power On Time, Power Off Time, MTE, EU, Power Supplies, Code Major Version, Date, Time, Startup Failure, LRU Failure, LRU Disabled, PCI Failure, PCI Fail After Success, Lane Training Failure, Fatal, Failure Description

sub monthToNum
{
    my ($month) = @_;
    my $num     = 1;

    for ($month) {
        if    (/Jan/) { $num = 1;  }
        elsif (/Feb/) { $num = 2;  }
        elsif (/Mar/) { $num = 3;  }
        elsif (/Apr/) { $num = 4;  }
        elsif (/May/) { $num = 5;  }
        elsif (/Jun/) { $num = 6;  }
        elsif (/Jul/) { $num = 7;  }
        elsif (/Aug/) { $num = 8;  }
        elsif (/Sep/) { $num = 9;  }
        elsif (/Oct/) { $num = 10; }
        elsif (/Nov/) { $num = 11; }
        elsif (/Dec/) { $num = 12; }
    }
    return $num;
}

sub dumpPieces
{
    my @pieces = @_;
    my $count = 0;
    foreach my $piece (@pieces) # dump each item 
    {
        print "piece[", $count++, "] = --", $piece, "--\n";
    }
}

sub matchPiece
{
    my ($match) = shift;
    my @pieces = @_;
    my $count = 0;
    foreach my $piece (@pieces)
    {
        if ($piece eq $match)
        {
            return $count;
        }
        $count++;
    }
    return -1;
}

sub printErr
{
    my ($startUpErr, $thisMsg)            = @_;
    print ",", $RunNumber, ",", $ESSMode, ",", $PowerOnTime, ",", $PowerOffTime, ",", $MTE, ",", $EU, ",", $PowerSupplies, ",", $CodeMajorVersion, ",", $thisDate, ",", $thisTime, ",", $startUpErr, ",", 
    (($leftSideReport) ? "Left" : "Right"), $thisMsg;
}

sub parseFile
{
    my ($fileName)           = @_;
    my @pieces               = ();
    my $thisLine             = '';
    my $trimmedLine          = '';
    my $cycleNumber          = 0;
    my $testNumber           = 0;
    my $lastTime             = '';
    my $thisHour             = 0;
    my $lastHour             = 0;
    my $cycleFailures        = 0;
    my $testFailures         = 0;
    my $finishLastCycle      = 0;
    my $powerCycle           = 1;
    my $foundFirstReport     = 0;
    my $thisTemperature      = 0;
    my $thisName             = "";
    my $thisPowerSupply      = "";
    my $thisCurrent          = 0;
    my $thisVoltage          = 0;
    my $thisVersName         = "";
    my $thisCRC              = "";
    my $thisOne              = 0;
    my $thisVersionPass      = "";
    my $rightSummaryLine     = 0;
    my $leftSummaryLine      = 0;
    my $powerCycleFirstCycle = 0;
    my $fileLineCount        = 1;
    my $p                    = "00000000p";
    my $pf                   = "[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][pf]";

    $thisDate = $Month . "/" . $Day . "/" . $Year;
    open FILE, "$fileName" or die "Could not open file : $!\n";

    while (<FILE>) 
    {
        $rightSummaryLine = 0;
        $leftSummaryLine  = 0;

        if (defined($_))
        {
            chomp($_);
            @pieces = split(' ', $_);
            $thisLine    = $_;
            $trimmedLine = $thisLine;
            $trimmedLine =~ s/^\s+//;
            if ($thisLine eq "Power Cycle -")
            {
                $powerCycle = 1;
            }
            if ($thisLine =~ /^MTE PC Name: /)
            {
                $MTE = $pieces[3];
            }
            if ($thisLine =~/^MODE: /)
            {
                $ESSMode = $pieces[1];
            }
            if ($thisLine =~ /^UNIT S.N: /)
            {
                $EU = "EU #" . $pieces[2];
            }
            if ($thisLine =~ /^DATE: /)
            {
                $Day   = $pieces[1];
                $Month = &monthToNum($pieces[2]);
                $Year  = $pieces[3];
                $thisDate = $Month . "/" . $Day . "/" . $Year;
            }

# We want to find the lines that indicate the test we are on
            if ((length($thisLine) > 36) && (defined(substr($thisLine, 37, 6))))
            {
                if ($thisLine =~ / Left  /) 
                { # Left header line
# When we find a Left line, we need to finish processing the
# previous test cycle
                    $leftSummaryLine = 1;
                    $leftSideReport  = 1;
                    if ($finishLastCycle) # handle the summary of the last cycle
                    {
                    }
                    if ($powerCycle)
                    {
                        $powerCycleFirstCycle = 1;
                        $powerCycle = 0;
                    }
                    else
                    {
                        $powerCycleFirstCycle = 0;
                    }
                    $cycleNumber       = $pieces[0];
                    $cycleFailures     = $pieces[1];
                    $thisTime          = $pieces[2];
                    if (!$foundFirstReport)
                    {
                        $lastTime = $thisTime;
                    }
                    $thisHour = $thisTime;
                    $thisHour =~ s/:.*//;
                    $lastHour = $lastTime;
                    $lastHour =~ s/:.*//;
                    if ($lastHour > $thisHour)
                    {
                        $Day++;
                        $thisDate = $Month . "/" . $Day . "/" . $Year;
                    }
                    $lineInCycleReport = 1;
                    $lastTime = $thisTime;
                    $foundFirstReport  = 1;
                }
                elsif ($thisLine =~ / Right /) 
                { # Right header line
                    $rightSummaryLine = 1;
                    $leftSideReport   = 0;
                    $testNumber       = $pieces[0];
                    $testFailures     = $pieces[1];
                }
            }

            if ($foundFirstReport)
            {
                if ($leftSummaryLine)
                {
                    # find the version we are testing
                    if ($thisLine =~ / ([AB]) (\d\.\d\d) (\d\d\.\d) ([A-Z][A-Z][A-Z])([0-9a-fA-F]{8})([pf])/)
                    {
                        $thisPowerSupply = $1;
                        $thisCurrent     = $2 + 0;
                        $thisVoltage     = $3 + 0;
                        $thisVersName    = $4;
                        $thisCRC         = $5;
                        $thisVersionPass = $6;
                        if (($thisVersName eq "DPB") && ($thisVersionPass eq "f"))
                        {
                            &printErr("Yes", ",SP,No,No,No,No,No,DP Boot Code Wrong Version\n");
                            $thisOne = matchPiece($thisVersName . $thisCRC . $thisVersionPass, @pieces);
                            $pieces[$thisOne] =~ s/f/q/;
                        }
                        if (($thisVersName eq "KDI") && ($thisVersionPass eq "f"))
                        {
                            &printErr("Yes", ",SP,No,No,No,No,No,KDI Image Wrong Version\n");
                            $thisOne = matchPiece($thisVersName . $thisCRC . $thisVersionPass, @pieces);
                            $pieces[$thisOne] =~ s/f/q/;
                        }
                        if (($thisVersName eq "LFS") && ($thisVersionPass eq "f"))
                        {
                            &printErr("Yes", ",SP,No,No,No,No,No,Local File System Wrong Version\n");
                            $thisOne = matchPiece($thisVersName . $thisCRC . $thisVersionPass, @pieces);
                            $pieces[$thisOne] =~ s/f/q/;
                        }
                        if (($thisVersName eq "UFS") && ($thisVersionPass eq "f"))
                        {
                            &printErr("Yes", ",SP,No,No,No,No,No,User File System Wrong Version\n");
                            $thisOne = matchPiece($thisVersName . $thisCRC . $thisVersionPass, @pieces);
                            $pieces[$thisOne] =~ s/f/q/;
                        }
                        if (($thisVersName eq "FPG") && ($thisVersionPass eq "f"))
                        {
                            &printErr("Yes", ",SP,No,No,No,No,No,FPGA Wrong Version\n");
                            $thisOne = matchPiece($thisVersName . $thisCRC . $thisVersionPass, @pieces);
                            $pieces[$thisOne] =~ s/f/q/;
                        }
                    }
                }
                elsif ($rightSummaryLine)
                {
                    # find the version we are testing
                    if ($thisLine =~ / ([AB]) (\d\.\d\d) (\d\d\.\d) ([A-Z][A-Z][A-Z])([0-9a-fA-F]{8})([pf])/)
                    {
                        $thisPowerSupply = $1;
                        $thisCurrent     = $2 + 0;
                        $thisVoltage     = $3 + 0;
                        $thisVersName    = $4;
                        $thisCRC         = $5;
                        $thisVersionPass = $6;
                        if (($thisVersName eq "DPB") && ($thisVersionPass eq "f"))
                        {
                            &printErr("Yes", ",SP,No,No,No,No,No,DP Boot Code Wrong Version\n");
                            $thisOne = matchPiece($thisVersName . $thisCRC . $thisVersionPass, @pieces);
                            $pieces[$thisOne] =~ s/f/q/;
                        }
                        if (($thisVersName eq "KDI") && ($thisVersionPass eq "f"))
                        {
                            &printErr("Yes", ",SP,No,No,No,No,No,KDI Image Wrong Version\n");
                            $thisOne = matchPiece($thisVersName . $thisCRC . $thisVersionPass, @pieces);
                            $pieces[$thisOne] =~ s/f/q/;
                        }
                        if (($thisVersName eq "LFS") && ($thisVersionPass eq "f"))
                        {
                            &printErr("Yes", ",SP,No,No,No,No,No,Local File System Wrong Version\n");
                            $thisOne = matchPiece($thisVersName . $thisCRC . $thisVersionPass, @pieces);
                            $pieces[$thisOne] =~ s/f/q/;
                        }
                        if (($thisVersName eq "UFS") && ($thisVersionPass eq "f"))
                        {
                            &printErr("Yes", ",SP,No,No,No,No,No,User File System Wrong Version\n");
                            $thisOne = matchPiece($thisVersName . $thisCRC . $thisVersionPass, @pieces);
                            $pieces[$thisOne] =~ s/f/q/;
                        }
                        if (($thisVersName eq "FPG") && ($thisVersionPass eq "f"))
                        {
                            &printErr("Yes", ",SP,No,No,No,No,No,FPGA Wrong Version\n");
                            $thisOne = matchPiece($thisVersName . $thisCRC . $thisVersionPass, @pieces);
                            $pieces[$thisOne] =~ s/f/q/;
                        }
                    }
                }
                if (($lineInCycleReport == 1) || ($lineInCycleReport == 9))
                {
                    if ($thisLine =~ / SP0000:00:00f /)
                    {
                        &printErr("No", ",SP,No,No,No,No,No,SP ETI Failure\n");
                        $pieces[8] =~ s/f/q/;
                    }
                    if ($thisLine =~ / PS0000:00:00f /)
                    {
                        &printErr("No", ",LVPS,No,No,No,No,No,LVPS ETI Failure\n");
                        $pieces[8] =~ s/f/q/;
                    }
                    if ($thisLine =~ / VP0000:00:00f /)
                    {
                        &printErr("No", ",VP,No,No,No,No,No,VP ETI Failure\n");
                        $pieces[8] =~ s/f/q/;
                    }
                    if ($thisLine =~ / FC0000:00:00f /)
                    {
                        &printErr("No", ",FC,No,No,No,No,No,FC ETI Failure\n");
                        $pieces[8] =~ s/f/q/;
                    }

                    if ($thisLine =~ / DT0000:00:00f /)
                    {
                        &printErr("No", ",DU,No,No,No,No,No,DU TS ETI Failure\n");
                        $pieces[8] =~ s/f/q/;
                    }

                    if ($thisLine =~ / C100020000f /)
                    {
                        &printErr("No", ",LVPS,No,No,No,No,No,LVPS Validity Fault\n");
                        if ($pieces[17] =~ /C100020000f/)
                        {
                            $pieces[17] =~ s/f/q/;
                        }
                        if ($pieces[18] =~ /C100020000f/)
                        {
                            $pieces[18] =~ s/f/q/;
                        }
                    }

                    if ($thisLine =~ / C200000008f /)
                    {
                        &printErr("No", ",IO,No,No,No,No,No,Discrete Output Sense Mismatch\n");
                        if ($pieces[17] =~ /C200000008f/)
                        {
                            $pieces[17] =~ s/f/q/;
                        }
                        if ($pieces[18] =~ /C200000008f/)
                        {
                            $pieces[18] =~ s/f/q/;
                        }
                    }
                    if ($thisLine =~ / P100200000f /)
                    { # lab load FPGA on the Left or Right side, we will not count this as an error
                        if ($pieces[17] =~ /P100200000f/)
                        {
                            $pieces[17] =~ s/f/q/;
                        }
                        if ($pieces[18] =~ /P100200000f/)
                        {
                            $pieces[18] =~ s/f/q/;
                        }
                    }

                    if ($thisLine =~ / CH00000001f /)
                    {
                        &printErr("No", ",DU,No,No,No,No,No,DU Backlight Temp Sensor Fault\n");
                        if ($lineInCycleReport == 1)
                        {
                            $pieces[26] =~ s/f/q/;
                        }
                        else
                        {
                            $pieces[27] =~ s/f/q/;
                        }
                    }

                    if ($thisLine =~ / CH40000000f /)
                    {
                        &printErr("No", ",DU,No,No,No,No,No,DU TS Protocol Version Fault\n");
                        if ($lineInCycleReport == 1)
                        {
                            $pieces[26] =~ s/f/q/;
                        }
                        else
                        {
                            $pieces[27] =~ s/f/q/;
                        }
                    }
                    if ($thisLine =~ / PB00010000f /)
                    {
                        &printErr("No", ",DU,No,No,No,No,No,DU LUT Version Fault\n");
                        if ($pieces[26] =~ /PB00010000f/)
                        {
                            $pieces[26] =~ s/f/q/;
                        }
                        else
                        {
                            $pieces[27] =~ s/f/q/;
                        }
                    }

                    if ($thisLine =~ / G110000000f /)
                    {
                        &printErr("Yes", ",SP,No,No,No,No,No,SP OGL 3 Under Threshold\n");
                        if ($pieces[18] =~ /G110000000f/)
                        {
                            $pieces[18] =~ s/f/q/;
                        }
                        else
                        {
                            $pieces[19] =~ s/f/q/;
                        }
                    }

                    if ($thisLine =~ / G200000030f /)
                    {
                        &printErr("No", ",SP,No,No,No,No,No,FC/AV Video Input 1 Timeout\n");
                        &printErr("No", ",SP,No,No,No,No,No,FC/AV Video Input 2 Timeout\n");
                        if ($pieces[18] =~ /G200000030f/)
                        {
                            $pieces[18] =~ s/f/q/;
                        }
                        else
                        {
                            $pieces[19] =~ s/f/q/;
                        }
                    }


                    if ($thisLine =~ / G500008000f /)
                    {
                        &printErr("No", ",SP,No,No,No,No,No,Initial CST Failed\n");
                        if ($pieces[18] =~ /G500008000f/)
                        {
                            $pieces[18] =~ s/f/q/;
                        }
                        else
                        {
                            $pieces[19] =~ s/f/q/;
                        }
                    }

                    if ($thisLine =~ / G73E000000f /)
                    {
                        &printErr("No", ",DU,No,No,No,No,No,DU POST Failure\n");
                        if ($pieces[18] =~ /G73E000000f/)
                        {
                            $pieces[18] =~ s/f/q/;
                        }
                        else
                        {
                            $pieces[19] =~ s/f/q/;
                        }
                    }

                    if ($thisLine =~ / G83E000000f /)
                    {
                        &printErr("No", ",DU,No,No,No,No,No,DU POST Failure\n");
                        if ($pieces[18] =~ /G83E000000f/)
                        {
                            $pieces[18] =~ s/f/q/;
                        }
                        else
                        {
                            $pieces[19] =~ s/f/q/;
                        }
                    }

                    if ($thisLine =~ / G810000080f /)
                    {
                        &printErr("No", ",DU,No,No,No,No,No,DU POST Failure\n");
                        &printErr("No", ",IO,No,No,No,No,No,IO Under Temperature\n");
                        if ($pieces[18] =~ /G810000080f/)
                        {
                            $pieces[18] =~ s/f/q/;
                        }
                        else
                        {
                            $pieces[19] =~ s/f/q/;
                        }
                    }

                    if ($thisLine =~ / G800000080f /)
                    {
                        &printErr("No", ",DU,No,No,No,No,No,DU POST Failure\n");
                        if ($pieces[18] =~ /G800000080f/)
                        {
                            $pieces[18] =~ s/f/q/;
                        }
                        else
                        {
                            $pieces[19] =~ s/f/q/;
                        }
                    }
                    if ($thisLine =~ / G980000000f /)
                    {
                        &printErr("No", ",VP,No,No,No,No,No,VP Config Done not set in IPC Flags\n");
                        if ($pieces[18] =~ /G980000000f/)
                        {
                            $pieces[18] =~ s/f/q/;
                        }
                        else
                        {
                            $pieces[19] =~ s/f/q/;
                        }
                    }


                    if ($thisLine =~ / G1000000001f /)
                    {
                        &printErr("No", ",VP,No,No,No,No,No,Node Right Side not set in IPC Flags\n");
                        if ($pieces[18] =~ /G1000000001f /)
                        {
                            $pieces[18] =~ s/f/q/;
                        }
                        else
                        {
                            $pieces[19] =~ s/f/q/;
                        }
                    }

                    if ($thisLine =~ / \d\.\d\/\d\.\d\d\d f /)
                    {
                        &printErr("No", ",SP,No,No,No,No,No,SP Bezel Voltage Failure\n");
# &dumpPieces(@pieces);
                        $pieces[12] =~ s/f/q/;
                    }
                }

                if ($thisLine =~ / G100000080f /)
                {
                    &printErr("Yes", ",PS,No,No,No,No,No,Power Supply Register Error\n");
                    $pieces[matchPiece('G100000080f', @pieces)] =~ s/f/q/;
                }
                if ($thisLine =~ / G200800000f /)
                {
                    &printErr("No", ",VP,No,No,No,No,No,VP Module Over Temperature\n");
                    $pieces[matchPiece('G200800000f', @pieces)] =~ s/f/q/;
                }
                if ($thisLine =~ / G200400000f /)
                {
                    &printErr("No", ",SP,No,No,No,No,No,SP Module Over Temperature\n");
                    $pieces[matchPiece('G200400000f', @pieces)] =~ s/f/q/;
                }
                if ($thisLine =~ / C200000003f /)
                {
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    $pieces[matchPiece('C200000003f', @pieces)] =~ s/f/q/;
                }
                if ($thisLine =~ / C200000083f /)
                {
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    &printErr("No", ",SP,No,No,No,No,No,CBIT SP Temperature Warning\n");
                    $pieces[matchPiece('C200000083f', @pieces)] =~ s/f/q/;
                }
                if ($thisLine =~ / C200000203f /)
                {
                    &printErr("No", ",VP,No,No,No,No,No,CBIT VP Temperature Warning\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    $pieces[matchPiece('C200000203f', @pieces)] =~ s/f/q/;
                }
                if ($thisLine =~ / C200000603f /)
                {
                    &printErr("No", ",VP,No,No,No,No,No,CBIT VP Temperature Warning\n");
                    &printErr("No", ",VP,No,No,No,No,No,CBIT VP Over Temp Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    $pieces[matchPiece('C200000603f', @pieces)] =~ s/f/q/;
                }
                if ($thisLine =~ / C200008603f /)
                {
                    &printErr("No", ",VP,No,No,No,No,No,CBIT VP Temperature Warning\n");
                    &printErr("No", ",VP,No,No,No,No,No,CBIT VP Over Temp Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS Temperature Warning\n");
                    $pieces[matchPiece('C200008603f', @pieces)] =~ s/f/q/;
                }
                if ($thisLine =~ / C200018603f /)
                {
                    &printErr("No", ",VP,No,No,No,No,No,CBIT VP Temperature Warning\n");
                    &printErr("No", ",VP,No,No,No,No,No,CBIT VP Over Temp Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS Temperature Warning\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS Over Temp Fault\n");
                    $pieces[matchPiece('C200018603f', @pieces)] =~ s/f/q/;
                }
                if ($thisLine =~ / C200018683f /)
                {
                    &printErr("No", ",VP,No,No,No,No,No,CBIT VP Temperature Warning\n");
                    &printErr("No", ",VP,No,No,No,No,No,CBIT VP Over Temp Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS Temperature Warning\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS Over Temp Fault\n");
                    &printErr("No", ",SP,No,No,No,No,No,CBIT SP Temperature Warning\n");
                    $pieces[matchPiece('C200018683f', @pieces)] =~ s/f/q/;
                }
                if ($thisLine =~ / C200008083f /)
                {
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    &printErr("No", ",SP,No,No,No,No,No,CBIT SP Temperature Warning\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS Temperature Warning\n");
                    $pieces[matchPiece('C200008083f', @pieces)] =~ s/f/q/;
                }
                if ($thisLine =~ / C200008183f /)
                {
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    &printErr("No", ",SP,No,No,No,No,No,CBIT SP Temperature Warning\n");
                    &printErr("No", ",SP,No,No,No,No,No,CBIT SP Over Temp Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS Temperature Warning\n");
                    $pieces[matchPiece('C200008183f', @pieces)] =~ s/f/q/;
                }
                if ($thisLine =~ / C200018183f /)
                {
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    &printErr("No", ",SP,No,No,No,No,No,CBIT SP Temperature Warning\n");
                    &printErr("No", ",SP,No,No,No,No,No,CBIT SP Over Temp Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS Temperature Warning\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS Over Temp Fault\n");
                    $pieces[matchPiece('C200018183f', @pieces)] =~ s/f/q/;
                }

                if (($thisLine =~ /^\s+EU POST: 00200000f/) && ($pieces[2] eq "00200000f"))
                { # lab load FPGA on the Left or Right side, we will not count this as an error
                    $pieces[2] = "00200000q"; # Cancel out the error
                }

                if (($thisLine =~ / EU CBIT: 00020000f/) && ($pieces[10] eq "00020000f"))
                {
                    &printErr("No", ",LVPS,No,No,No,No,No,LVPS Validity Fault\n");
                    $pieces[10]  =~ s/f/q/; # Cancel out the error
                }

                if (($thisLine =~ / EU CBIT: $p 00000003f /) && ($pieces[11] eq "00000003f"))
                {
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    $pieces[11]  =~ s/f/q/; # Cancel out the error
                }
                if (($thisLine =~ / EU CBIT: $p 00000083f /) && ($pieces[11] eq "00000083f"))
                {
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    &printErr("No", ",SP,No,No,No,No,No,CBIT SP Temperature Warning\n");
                    $pieces[11]  =~ s/f/q/; # Cancel out the error
                }
                if (($thisLine =~ / EU CBIT: $p 00000203f /) && ($pieces[11] eq "00000203f"))
                {
                    &printErr("No", ",VP,No,No,No,No,No,CBIT VP Temperature Warning\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    $pieces[11]  =~ s/f/q/; # Cancel out the error
                }
                if (($thisLine =~ / EU CBIT: $p 00000603f /) && ($pieces[11] eq "00000603f"))
                {
                    &printErr("No", ",VP,No,No,No,No,No,CBIT VP Temperature Warning\n");
                    &printErr("No", ",VP,No,No,No,No,No,CBIT VP Over Temp Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    $pieces[11]  =~ s/f/q/; # Cancel out the error
                }
                if (($thisLine =~ / EU CBIT: $p 00008083f /) && ($pieces[11] eq "00008083f"))
                {
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    &printErr("No", ",SP,No,No,No,No,No,CBIT SP Temperature Warning\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS Temperature Warning\n");
                    $pieces[11]  =~ s/f/q/; # Cancel out the error
                }
                if (($thisLine =~ / EU CBIT: $p 00008183f /) && ($pieces[11] eq "00008183f"))
                {
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    &printErr("No", ",SP,No,No,No,No,No,CBIT SP Temperature Warning\n");
                    &printErr("No", ",SP,No,No,No,No,No,CBIT SP Over Temp Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS Temperature Warning\n");
                    $pieces[11]  =~ s/f/q/; # Cancel out the error
                }
                if (($thisLine =~ / EU CBIT: $p 00018183f /) && ($pieces[11] eq "00018183f"))
                {
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    &printErr("No", ",SP,No,No,No,No,No,CBIT SP Temperature Warning\n");
                    &printErr("No", ",SP,No,No,No,No,No,CBIT SP Over Temp Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS Temperature Warning\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS Over Temp Fault\n");
                    $pieces[11]  =~ s/f/q/; # Cancel out the error
                }
                if (($thisLine =~ / EU CBIT: $p 00008603f /) && ($pieces[11] eq "00008603f"))
                {
                    &printErr("No", ",VP,No,No,No,No,No,CBIT VP Temperature Warning\n");
                    &printErr("No", ",VP,No,No,No,No,No,CBIT VP Over Temp Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS Temperature Warning\n");
                    $pieces[11]  =~ s/f/q/; # Cancel out the error
                }
                if (($thisLine =~ / EU CBIT: $p 00018603f /) && ($pieces[11] eq "00018603f"))
                {
                    &printErr("No", ",VP,No,No,No,No,No,CBIT VP Temperature Warning\n");
                    &printErr("No", ",VP,No,No,No,No,No,CBIT VP Over Temp Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS Temperature Warning\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS Over Temp Fault\n");
                    $pieces[11]  =~ s/f/q/; # Cancel out the error
                }
                if (($thisLine =~ / EU CBIT: $p 00018683f /) && ($pieces[11] eq "00018683f"))
                {
                    &printErr("No", ",VP,No,No,No,No,No,CBIT VP Temperature Warning\n");
                    &printErr("No", ",VP,No,No,No,No,No,CBIT VP Over Temp Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 5 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS 26 Volt Fault\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS Temperature Warning\n");
                    &printErr("No", ",PS,No,No,No,No,No,CBIT PS Over Temp Fault\n");
                    &printErr("No", ",SP,No,No,No,No,No,CBIT SP Temperature Warning\n");
                    $pieces[11]  =~ s/f/q/; # Cancel out the error
                }
                if (($thisLine =~ / EU CBIT: $p 00000008f /) && ($pieces[11] eq "00000008f"))
                {
                    &printErr("No", ",IO,No,No,No,No,No,Discrete Output Sense Mismatch\n");
                    $pieces[11]  =~ s/f/q/; # Cancel out the error
                }
############### GP: 1-10 Faults, First Word
                if (($thisLine =~ /^\s+GP: 1-10: 00000080f $pf $pf $p $p $p $p /) && ($pieces[2] eq "00000080f"))
                {
                    &printErr("Yes", ",PS,No,No,No,No,No,Power Supply Register Error\n");
                    $pieces[2] =~ s/f/q/;
                }

                if (($thisLine =~ /^\s+GP: 1-10: 00001000f $p $p $p $p $p $p /) && ($pieces[2] eq "00001000f"))
                {
                    &printErr("Yes", ",VP,No,No,No,No,No,VP Video Input Memory Failure\n");
                    $pieces[2] =~ s/f/q/;
                }

                if (($thisLine =~ /^\s+GP: 1-10: 02000000f $p $p $p $p $p $p /) && ($pieces[2] eq "02000000f"))
                {
                    &printErr("No", ",IO,No,No,No,No,No,STOF Pulse Rate fell below 70Hz\n");
                    $pieces[2] =~ s/f/q/;
                }

                if (($thisLine =~ /^\s+GP: 1-10: 10000000f $p $p $p /) && ($pieces[2] eq "10000000f"))
                {
                    &printErr("Yes", ",SP,No,No,No,No,No,SP OGL 3 Under Threshold\n");
                    $pieces[2] =~ s/f/q/;
                }

############### GP: 1-10 Faults, Second Word
                if (($thisLine =~ /^\s+GP: 1-10: $p 00000002f $p $p $p /) && ($pieces[3] =~ /00000002f/))
                {
                    &printErr("No", ",SP,No,No,No,No,No,FW Rate Under Threshold\n");
                    $pieces[3]  =~ s/f/q/; # Cancel out the error
                }

                if (($thisLine =~ /^\s+GP: 1-10: $p 00000030f $p $p $p /) && ($pieces[3] =~ /00000030f/))
                {
                    &printErr("No", ",SP,No,No,No,No,No,FC/AV Video Input 1 Timeout\n");
                    &printErr("No", ",SP,No,No,No,No,No,FC/AV Video Input 2 Timeout\n");
                    $pieces[3]  =~ s/f/q/; # Cancel out the error
                }

                if (($thisLine =~ /^\s+GP: 1-10: $p 00200003f $p $p $p /) && ($pieces[3] =~ /00200003f/))
                {
                    &printErr("No", ",FC,No,No,No,No,No,FC Loss Of Sync Port 3 \n");
                    &printErr("No", ",SP,No,No,No,No,No,Fibre Channel Rate Under Threshold\n");
                    &printErr("No", ",SP,No,No,No,No,No,FW Rate Under Threshold\n");
                    $pieces[3]  =~ s/f/q/; # Cancel out the error
                }

                if (($thisLine =~ /^\s+GP: 1-10: $pf 00400000f $p $p $p /) && ($pieces[3] =~ /00400000f/))
                {
                    &printErr("No", ",SP,No,No,No,No,No,SP Module Over Temperature\n");
                    $pieces[3]  =~ s/f/q/; # Cancel out the error
                }

                if (($thisLine =~ /^\s+GP: 1-10: $pf 00800000f $pf $p $p /) && ($pieces[3] =~ /00800000f/))
                {
                    &printErr("No", ",VP,No,No,No,No,No,VP Module Over Temperature\n");
                    $pieces[3]  =~ s/f/q/; # Cancel out the error
                }

############### GP: 1-10 Faults, Third Word
                if (($thisLine =~ /^\s+GP: 1-10: $pf $pf 00000800f $p $p /) && ($pieces[4] =~ /00000800f/))
                {
                    &printErr("Yes", ",SP,No,No,No,No,No,SP FPGA is not valid for this config\n");
                    $pieces[4]  =~ s/f/q/; # Cancel out the error
                }
                if (($thisLine =~ /^\s+GP: 1-10: $p $p 00F00800f $p /) && ($pieces[4] =~ /00F00800f/))
                {
                    &printErr("Yes", ",SP,No,No,No,No,No,SP FPGA is not valid for this config\n");
                    &printErr("Yes", ",DP,No,No,No,No,No,DP Boot is not valid for this config\n");
                    &printErr("Yes", ",DP,No,No,No,No,No,KDI is not valid for this config\n");
                    &printErr("Yes", ",DP,No,No,No,No,No,User FS is not valid for this config\n");
                    &printErr("Yes", ",DP,No,No,No,No,No,Local FS is not valid for this config\n");
                    $pieces[4]  =~ s/f/q/; # Cancel out the error
                }
                if (($thisLine =~ /^\s+GP: 1-10: $pf $pf 00100000f $p $p /) && ($pieces[4] =~ /00100000f/))
                {
                    &printErr("Yes", ",DP,No,No,No,No,No,DP Boot is not valid for this config\n");
                    $pieces[4]  =~ s/f/q/; # Cancel out the error
                }
                if (($thisLine =~ /^\s+GP: 1-10: $pf $pf 00200000f $p $p /) && ($pieces[4] =~ /00200000f/))
                {
                    &printErr("Yes", ",DP,No,No,No,No,No,KDI is not valid for this config\n");
                    $pieces[4]  =~ s/f/q/; # Cancel out the error
                }
                if (($thisLine =~ /^\s+GP: 1-10: $pf $pf 00400000f $p $p /) && ($pieces[4] =~ /00400000f/))
                {
                    &printErr("Yes", ",DP,No,No,No,No,No,User FS is not valid for this config\n");
                    $pieces[4]  =~ s/f/q/; # Cancel out the error
                }
                if (($thisLine =~ /^\s+GP: 1-10: $pf $pf 00800000f $p $p /) && ($pieces[4] =~ /00800000f/))
                {
                    &printErr("Yes", ",DP,No,No,No,No,No,Local FS is not valid for this config\n");
                    $pieces[4]  =~ s/f/q/; # Cancel out the error
                }

############### GP: 1-10 Faults, Fourth Word
                if (($thisLine =~ /^\s+GP: 1-10: $p $p $p 00000008f $p /) && ($pieces[5] =~ /00000008f/))
                {
                    &printErr("No", ",SP,No,No,No,No,No,FW Rate Under Threshold\n");
                    $pieces[5]  =~ s/f/q/; # Cancel out the error
                }


############### GP: 1-10 Faults, Fifth Word
                if (($thisLine =~ /^\s+GP: 1-10: [01]0000000[pf] $p $pf $p 00008000f $pf /) && ($pieces[6] =~ /00008000f/))
                {
                    &printErr("No", ",SP,No,No,No,No,No,Initial CST Failed\n");
                    $pieces[6]  =~ s/f/q/; # Cancel out the error
                }

############### GP: 1-10 Faults, Sixth Word
                if (($thisLine =~ /^\s+GP: 1-10: $p 0000000[02][pf] $pf $p $pf 00000200f /) && ($pieces[7] =~ /00000200f/))
                {
                    &printErr("No", ",DP,No,No,No,No,No,OTP LM Part Number Cross Check Failed\n");
                    $pieces[7]  =~ s/f/q/; # Cancel out the error
                }

                if (($thisLine =~ /^\s+GP: 1-10: $p 0000000[02][pf] $p $p $p 00010000f /) && ($pieces[7] =~ /00010000f/))
                {
                    &printErr("No", ",SP,No,No,No,No,No,FW Link Layer Receiver Overrun\n");
                    $pieces[7]  =~ s/f/q/; # Cancel out the error
                }

                if (($thisLine =~ /^\s+GP: 1-10: $p 0000000[02][pf] $p $p 0000[08]000[pf] 000[01]0000[pf] 3E00[0128]000f 3E00[0128]000f $p $p/) &&
                    ($pieces[8] =~ /3E00[0128]000f/) &&
                    ($pieces[9] =~ /3E00[0128]000f/))
                {
                    &printErr("No", ",DU,No,No,No,No,No,DU POST Failure\n");
                    $pieces[8]  =~ s/f/q/; # Cancel out the error
                    $pieces[9] =~ s/f/q/;
                }

                if (($thisLine =~ /^\s+GP: 1-10: .0000000[pf] 0000000[02][pf] $p $p 0000[08]000[pf] 000[01]0000[pf] 20......f 20......f $p 00[089]00000[pf]/) &&
                    ($pieces[8] =~ /20......f/) &&
                    ($pieces[9] =~ /20......f/))
                {
                    &printErr("No", ",DU,No,No,No,No,No,DU Backlight Temp Sensor Failure\n");
                    $pieces[8]  =~ s/f/q/; # Cancel out the error
                    $pieces[9] =~ s/f/q/;
                }

                if (($thisLine =~ /^\s+GP: 1-10: $p 0000000[02][pf] $p $p 0000[08]000[pf] $p $p 3E00[0128]000f $p $p/) &&
                    ($pieces[9] =~ /3E00[0128]000f/))
                {
                    &printErr("No", ",DU,No,No,No,No,No,DU POST Failure\n");
                    $pieces[9] =~ s/f/q/;
                }

                if (($thisLine =~ /^\s+GP: 1-10: $p $p $p $pf $p $p $p 00000020f $p $p/) &&
                    ($pieces[9] eq "00000020f"))
                {
                    &printErr("No", ",IO,No,No,No,No,No,Disc In Mismatch Exceeds 3s\n");
                    $pieces[9] =~ s/f/q/;
                }

                if (($thisLine =~ /^\s+GP: 1-10: $p $p $p $pf $p $p $p 00000080f $p $p/) &&
                    ($pieces[9] eq "00000080f"))
                {
                    &printErr("No", ",IO,No,No,No,No,No,Disc Out Mismatch Exceeds 3s\n");
                    $pieces[9] =~ s/f/q/;
                }

                if (($thisLine =~ /^\s+GP: 1-10: $p $p $p $p $p $p $p 08000080f $p $p/) &&
                    ($pieces[9] eq "08000080f"))
                {
                    &printErr("No", ",IO,No,No,No,No,No,Disc Out Mismatch Exceeds 3s\n");
                    &printErr("No", ",VP,No,No,No,No,No,VP Under Temperature\n");
                    $pieces[9] =~ s/f/q/;
                }

                if (($thisLine =~ /^\s+GP: 1-10: [01]0000000[pf] $p $p $p 0000[80]000[pf] $p $p 00001000f $p $p/) &&
                    ($pieces[9] eq "00001000f"))
                {
                    &printErr("No", ",SP,No,No,No,No,No,SP ETI Too Large\n");
                    $pieces[9] =~ s/f/q/;
                }
                if (($thisLine =~ /^\s+GP: 1-10: [01]000[01]000[pf] $p $p $p 0000[08]000[pf] $p $p 00002000f $p $p/) &&
                    ($pieces[9] eq "00002000f"))
                {
                    &printErr("No", ",VP,No,No,No,No,No,VP ETI Too Large\n");
                    $pieces[9] =~ s/f/q/;
                }
                if (($thisLine =~ /^\s+GP: 1-10: $p $p $p $p 0000[08]000[pf] $p $p 00008000f $p $p/) &&
                    ($pieces[9] eq "00008000f"))
                {
                    &printErr("No", ",FC,No,No,No,No,No,FC ETI Too Large\n");
                    $pieces[9] =~ s/f/q/;
                }
                if (($thisLine =~ /^\s+GP: 1-10: $p $p $p $p $p $p $p 00010000f $p $p/) &&
                    ($pieces[9] eq "00010000f"))
                {
                    &printErr("No", ",FC,No,No,No,No,No,BL ETI Too Small\n");
                    $pieces[9] =~ s/f/q/;
                }
                if (($thisLine =~ /^\s+GP: 1-10: [01]0000000[pf] $p $p $p $p $p $p 00[08]08000f $p $p/) &&
                    ($pieces[9] =~ "00[08]08000f"))
                {
                    &printErr("No", ",FC,No,No,No,No,No,SP ETI Too Small\n");
                    $pieces[9] =~ s/f/q/;
                }
############### GP: 1-10 Faults, Nineth Word
                if (($thisLine =~ /^\s+GP: 1-10: [01]0000000[pf] 00[02]000[03][03][pf] $p $p $p $p $p $p 80000000f 00[08]0000[01][pf]/) &&
                    ($pieces[10] =~ "80000000f"))
                {
                    &printErr("No", ",VP,No,No,No,No,No,VP Config Done not set in IPC Flags\n");
                    $pieces[10] =~ s/f/q/;
                }
############### GP: 1-10 Faults, Tenth Word
                if (($thisLine =~ /^\s+GP: 1-10: [01]0000000[pf] $p $p $p $p $p $p $p [08]0000000[pf] 00000001f/) &&
                    ($pieces[11] =~ "00000001f"))
                {
                    &printErr("No", ",VP,No,No,No,No,No,Node Right Side not set in IPC Flags\n");
                    $pieces[11] =~ s/f/q/;
                }
                if (($thisLine =~ /^\s+GP: 1-10: $p 000000[03]0[pf] $p $p $p $p $p $p [08]0000000[pf] 00100000f/) &&
                    ($pieces[11] =~ "00100000f"))
                {
                    &printErr("No", ",DU,No,No,No,No,No,DU EMI ETI Too Small\n");
                    $pieces[11] =~ s/f/q/;
                }
                if (($thisLine =~ /^\s+GP: 1-10: $p 000000[03]0[pf] $p $p $p $p ........[pf] ........[pf] [08]0000000[pf] 00900000f/) &&
                    ($pieces[11] =~ "00900000f"))
                {
                    &printErr("No", ",DU,No,No,No,No,No,DU BL  ETI Too Small\n");
                    &printErr("No", ",DU,No,No,No,No,No,DU EMI ETI Too Small\n");
                    $pieces[11] =~ s/f/q/;
                }
                if (($thisLine =~ /^\s+GP: 1-10: $p 000000[03]0[pf] $p $p $p $p ........[pf] ........[pf] [08]0000000[pf] 00800000f/) &&
                    ($pieces[11] =~ "00800000f"))
                {
                    &printErr("No", ",DU,No,No,No,No,No,TS ETI Too Small\n");
                    $pieces[11] =~ s/f/q/;
                }
############### GP: 11-16 Faults, Eleventh Word
                if (($thisLine =~ /^\s+GP: 11-16: 00000080f $p $p $p $p $p /) && ($pieces[2] eq "00000080f"))
                {
                    &printErr("No", ",FC,No,No,No,No,No,DU Unexpected Reset\n");
                    $pieces[2] =~ s/f/q/;
                }
############### DP POST, First Word
                if (($thisLine =~ /^\s+GP: 11-16: $p $p $p $p $p $p  DP POST: 00010000f /) && ($pieces[10] eq "00010000f"))
                {
                    &printErr("Yes", ",VP,No,No,No,No,No,DP POST Video Input Memory FAIL\n");
                    $pieces[10] =~ s/f/q/;
                }
                if (($thisLine =~ /^\s+DU POST: 00010000f  DU IBIT: $p  DU CBIT: /) && ($pieces[2] eq "00010000f"))
                {
                    &printErr("No", ",DU,No,No,No,No,No,DU LUT Version Fault\n");
                    $pieces[2]  =~ s/f/q/; # Cancel out the error
                }
                if (($thisLine =~ /^\s+DU POST: 000.0000.  DU IBIT: $p  DU CBIT: 40000000f $p/) && ($pieces[8] eq "40000000f"))
                {
                    &printErr("No", ",DU,No,No,No,No,No,DU TS Protocol Version Fault\n");
                    $pieces[8] =~ s/f/q/;
                }

                if (($thisLine =~ /^\s+DU POST: 000.0000.  DU IBIT: $p  DU CBIT: 00000001f $p/) && ($pieces[8] eq "00000001f"))
                {
                    &printErr("No", ",DU,No,No,No,No,No,DU Backlight Temp Sensor Fault\n");
                    $pieces[8] =~ s/f/q/;
                }
                if (($thisLine =~ /^\s+FW - SR:.*RxM:\s+[0-9]+f/) && ($pieces[9] =~ /[0-9]+f/))
                {
                    &printErr("No", ",SP,No,No,No,No,No,FW Rate Fault\n");
                    $pieces[9] =~ s/f/q/;
                }

                foreach my $piece (@pieces) # process each item to see if there was a failure
                {
                    if ($piece =~ /f$/)
                    {
                        print "\n\nUnhandled Error - $piece, file line count - $fileLineCount\n";
                        print "$trimmedLine\n";
                        exit(0);
                    }
                }
                $lineInCycleReport++;
            }
        }
        $fileLineCount++;
    }
    if ($finishLastCycle) # handle the summary of the last cycle
    {
    }
    close (FILE);
}

my @args = glob "@ARGV";
foreach my $arg (@args)
{
    print "parseFile($arg)\n";
    &parseFile($arg);
}


