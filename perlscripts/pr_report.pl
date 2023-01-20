###
#  pr_report.pl
#  This script scans the svn log messages for references to PRs. It prints out the log entries
#  by suspected PR numbers.
#
use strict;
use XML::Simple;
use Data::Dumper;
my $simple;
my $log;
my $logentry;
my $author;
my $i;
my $act;
my $msg;
my $pr;
my $prs;

# make sure this is greater than the highest PR number.
# (Used for rejecting numbers that are not PR numbers.)
my $maxPr = 6100;

## Set the entries in this array to describe all the paths and revisions
## to be reported on.
my @rel = (
  {
    'app'  => "EBL",
    'path' => "trunk/applications/EBL_Formal",
    'from' => "7097",
    'to'   => "7508",
  },
  {
    'app'  => "EBL_br",
    'path' => "branches/FTUa_ER/applications/EBL_Formal",
    'from' => "7508",
    'to'   => "7540",
  },
  {
    'app'  => "EBL_Lib",
    'path' => "trunk/development/SystemProcessor/Source/EBL_Formal",
    'from' => "7097",
    'to'   => "7508",
  },
  {
    'app'  => "EBL_Lib_br",
    'path' => "branches/FTUa_ER/development/SystemProcessor/Source/EBL_Formal",
    'from' => "7097",
    'to'   => "7509",
  },
  {
    'app'  => "OFP",
    'path' => "trunk",
    'from' => "6758",
    'to'   => "7508",
  },
  {
    'app'  => "OFP_br",
    'path' => "branches/FTUa_ER",
    'from' => "7509",
    'to'   => "7540",
  },
);

for $i ( 0 .. $#rel)
{
  my $app = $rel[$i]->{app};
  my $from = $rel[$i]->{from};
  my $to = $rel[$i]->{to};
  my $path = $rel[$i]->{path};


  print "PR's in logs for $app -> $path $from:$to\n";
  print "svn log --verbose --xml --revision $from:$to svn://training/jsfPCD_SP_Design/$path > pr_report.xml\n";
  system("svn log --verbose --xml --revision $from:$to svn://training/jsfPCD_SP_Design/$path > pr_report.xml");
  system ("copy pr_report.xml $app.xml >nul");

  $simple = XML::Simple->new(ForceArray => 1);
  $log = $simple->XMLin();
  $prs = {};

  for $i (0 .. $#{$log->{logentry}})
  {
    for my $k (0 .. $#{$log->{logentry}->[$i]->{msg}})
    {
      $msg  = $log->{logentry}->[$i]->{msg}[$k];

      if ($msg =~ /\bPR[\s-#s]/) # 'PR' 'PR-' 'PR#' 'PRs'
      {
        my @LoH = ();
        # while ($msg =~ /[\b-#]\d{4,7}[\b,)]?/)
        while ($msg =~ /\d{4,7}/)
        {
          $pr = $&;    # match string is the PR number
          $msg = $';   # continue with the rest of the message
          $pr =~ s/^0+//g;  # get rid of any leading 0's on PR number
          if ($pr < $maxPr)
          {
            push @{$prs->{$pr}}, $log->{logentry}->[$i];
          }
        }
      }
    }
  }

  my $le = @{$log->{logentry}} ;
  print "In $le revision log entries ";
  print "a total of ". keys ( %$prs) . " PR's were referenced\n\n";
  print "(some of these might be revision or other #'s, this is just a perl script after all)\n\n";
  foreach $pr (sort keys %$prs)
  {
    print "$pr\n";
  }
  print "\n";
  foreach $pr (sort keys %$prs)
  {
    my $LoH = $prs->{$pr};
    for $i (0 .. $#$LoH)
    {
      my $rev = %$prs->{$pr}[$i]{revision};
      my $author = %$prs->{$pr}[$i]{author}[0];
      my $date = %$prs->{$pr}[$i]{date}[0];
      print "PR $pr | r$rev | $author | $date \n";
      for my $j (0 .. $#{$prs->{$pr}[$i]->{paths}[0]->{path}})
      {
          print "    $prs->{$pr}[$i]->{paths}[0]->{path}[$j]->{action}";
          print " $prs->{$pr}[$i]->{paths}[0]->{path}[$j]->{content} \n";
      }
      print "\n";
      for my $k (0 .. $#{$prs->{$pr}[$i]->{msg}})
      {
        $msg  = $prs->{$pr}[$i]->{msg}[$k];
        print "  [ $msg  ]\n";
      }
      print "\n------------------------------------------------------------------\n";
    }
  }
  print "\n######################################################################\n";
}
## for debuging ## print Dumper ($log);

