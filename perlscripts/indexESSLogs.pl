#! C:\Perl\bin\perl.exe -w
    eval 'exec C:\Perl\bin\perl.exe -S $0 ${1+"$@"}'
        if 0; #$running_under_some_shell
use strict;
use warnings;
use File::Basename;
use File::Find ();
use Spreadsheet::WriteExcel;

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;
my $baseDir = '//L-3projects/projects/jsf-pcd/ESS/';

my %results = ();
sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);
    if ((($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    -f _ &&
    /^[23][0-5]\d\d 20\d\d-[01]\d-[0123]\d [012]\d.\d\d JSF EU ESS.txt\z/s) {
        print "Found - " . basename($name) . "\n";
        my ($unit, $year, $month, $day, $hour, $min) = 
            $name =~ /([23][0-5]\d\d) (20\d\d)-([01]\d)-([0123]\d) ([012]\d).(\d\d) JSF EU ESS.txt/;
        $results{"$year-$month-$day-$hour-$min-$unit"} = $name;
    }
}

File::Find::find({wanted => \&wanted}, $baseDir . 'EU Logs');
unlink('//Edmund/projects/jsf-pcd/ESS/index.xls');
my $workbook = Spreadsheet::WriteExcel->new($baseDir . 'index.xls');
$workbook->set_custom_color(20, 204, 255, 204);
my $ws = $workbook->add_worksheet('IndexLinks');
$ws->set_column('A:A', 15);
$ws->set_column('B:B', 5);
$ws->set_column('C:C', 85);
$ws->set_column('D:D', 6);
$ws->set_column('F:F', 8);
$ws->set_column('G:G', 5);
$ws->set_column('I:I', 7);
$ws->set_column('J:J', 7);
$ws->set_column('K:K', 100);
$ws->set_selection('B1');
my $fs = 10; # font size
my $fmt = $workbook->add_format(size => $fs);
my $fmtFailure = $workbook->add_format(size => $fs, bg_color => 'red');
my $boldFormat = $workbook->add_format(bg_color => 20, bold => 1, size => $fs);
my $dateFormat = $workbook->add_format(num_format => "mm/dd/yyyy hh:mm", align => 'left', size => $fs);
my $linkFormat = $workbook->add_format(align => 'left', size => $fs, color => 'blue', underline => 1);
my $dateFailure = $workbook->add_format(num_format => "mm/dd/yyyy hh:mm", align => 'left', size => $fs, bg_color => 'red');
my $linkFailure = $workbook->add_format(align => 'left', size => $fs, color => 'blue', underline => 1, bg_color => 'red');
$ws->write('A1', 'Date', $boldFormat);
$ws->write('B1', 'Unit', $boldFormat);
$ws->write('C1', 'Link', $boldFormat);
$ws->write('D1', 'OTP',  $boldFormat);
$ws->write('E1', 'MTE',  $boldFormat);
$ws->write('F1', 'Type', $boldFormat);
$ws->write('G1', 'Mode', $boldFormat);
$ws->write('H1', 'Oper', $boldFormat);
$ws->write('I1', 'Failures', $boldFormat);
$ws->write('J1', 'Total Failures', $boldFormat);
$ws->write('K1', 'Reason', $boldFormat);
my $row = 1;
for my $key (reverse sort keys %results) {
    my $thisName = $results{$key};
    print "Processing - " . basename($thisName) . "\n";
    my ($unit, $year, $month, $day, $hour, $min) = 
        $thisName =~ /([23][0-5]\d\d) (20\d\d)-([01]\d)-([0123]\d) ([012]\d).(\d\d) JSF EU ESS.txt/;
    # find failures and total failures
    my $thisTests = 0;
    my $thisTotalTests = 0;
    my $thisFailures = 0;
    my $thisTotalFailures = 0;
    my $lastFailures = 0;
    my $lastTotalFailures = 0;
    my $cumFailures = 0;
    my $cumTotalFailures = 0;
    open FILE, $thisName or die "Can not open $thisName : $!";
    while (<FILE>) {
        chomp;
        if (/^\s+(\d+)\s+(\d+)\s+\d\d:\d\d:\d\d\s+\S+\s+Left\s+([pfPF]{4}|EMI)\s+/) {
            ($thisTests, $thisFailures) = ($1,$2);
        }
        if (/^\s+(\d+)\s+(\d+)\s+\d\d:\d\d:\d\d\s+\S+\s+Right\s+([pfPF]{4}|EMI)\s+/) {
            ($thisTotalTests, $thisTotalFailures) = ($1,$2);
        } elsif (/^\s+(\d+)\s+(\d+)\s+\d\d:\d\d:\d\d$/) { # bug in old ESS format split the lines
            ($thisTotalTests, $thisTotalFailures) = ($1,$2);
        }
        if ($thisFailures == 0) { # handle the case where they have cleared the errors
            $cumFailures += $lastFailures;
        }
        if ($thisTotalFailures == 0) { # handle the case where they have cleared the errors
            $cumTotalFailures += $lastTotalFailures;
        }
        $lastFailures = $thisFailures;
        $lastTotalFailures = $thisTotalFailures;
    }
    $cumFailures += $lastFailures;
    $cumTotalFailures += $lastTotalFailures;
    close FILE;
    $ws->write_date_time($row, 0, "$year-$month-$day" . "T" . "$hour:$min", ($cumFailures || $cumTotalFailures) ? $dateFailure : $dateFormat);
    $ws->write($row, 1, $unit, ($cumFailures || $cumTotalFailures) ? $fmtFailure : $fmt);
    $ws->write($row, 2, "external:" . $thisName, ($cumFailures || $cumTotalFailures) ? $linkFailure : $linkFormat);
    $ws->write($row, 8, $cumFailures, ($cumFailures || $cumTotalFailures) ? $fmtFailure : $fmt);
    $ws->write($row, 9, $cumTotalFailures, ($cumFailures || $cumTotalFailures) ? $fmtFailure : $fmt);
    open FILE, $thisName or die "Can not open $thisName : $!";
    my $count = 0;
    my $foundTemperatureString = 0;
    my $otpVersion = "";
    while (<FILE>) {
        chomp;
        $otpVersion = $1 if (/JSF EU ESS DATA SHEET OTP ([\d\.]+)/);
        $ws->write_string($row, 4, $1, ($cumFailures || $cumTotalFailures) ? $fmtFailure : $fmt) if (/MTE PC Name: (\w+)/);
        $ws->write_string($row, 6, $1, ($cumFailures || $cumTotalFailures) ? $fmtFailure : $fmt) if (/MODE: (\w+)/);
        $ws->write_string($row, 7, $1, ($cumFailures || $cumTotalFailures) ? $fmtFailure : $fmt) if (/OPERATOR ID: (\w+)/);
        $ws->write_string($row, 10, $1, ($cumFailures || $cumTotalFailures) ? $fmtFailure : $fmt) if (/REASON: (.*)/);
        $foundTemperatureString = 1 if (/TEMPERATURE TESTING/);
        last if ($count++ > 30);
    }
    $ws->write_string($row, 3, $otpVersion, ($cumFailures || $cumTotalFailures) ? $fmtFailure : $fmt);
    if ($foundTemperatureString) {
        $ws->write_string($row, 5, "Chamber", ($cumFailures || $cumTotalFailures) ? $fmtFailure : $fmt);
    } else {
        $ws->write_string($row, 5, "", ($cumFailures || $cumTotalFailures) ? $fmtFailure : $fmt);
    }
    close FILE;
    $row++;
}

