package myfilter;
use strict; use warnings;

use Filter::Util::Call;


sub import {
  my ($self,)=@_;
  my ($found)=0;
  my $i=0;
  my $first_in_group;
  my $stepsp=0;
  my @behaves;

  filter_add( 
    sub {
      my ($status) ;

      if (($status = filter_read()) > 0) {
        if ($found == 0 and /Steps\(/) { 
          $found = 1; 
          $first_in_group = $i;
        }
        if ($found) {
          if (/Steps\(/) {
            my $string;
	    if (/=\s*Steps\(/) {
              s/Steps\(//;
	      chomp;
	      $stepsp = 1;
	      $string = $_;
	    } else {
	      $string = '';
	    }
#==============================================================================
            my $stuff0 = <<"STUFF0";
  _stEps(
STUFF0
	     $_ = $string . $stuff0;
#==============================================================================
	  } elsif (/;\s*\z/) {
            $found = 0;
            my $save = $_;
            my @sublist = @behaves[$first_in_group..($i-1)];
            my $str;
            for my $l (@sublist) {
              if (not(defined($l))) { $str .= 'undef, '; } 
              else { $str .= "'$l', "; }
            }

            my $k = $i-1;
#==============================================================================
            my $stuff1 = <<"STUFF1";
) 
STUFF1
	     $_ = $stuff1;
#==============================================================================

	    if ($stepsp) {
	      $_ .= ";\n";
	      $stepsp = 0;
	    } else {
	      $_ .= ",\n$save\n";
	    }
          } elsif (/(?<post_trans>FAILURE|ALWAYS|ASSERT)(\()(?<rest>\N.*)(\))\s*,\s*\z/) {
#==============================================================================
            my $stuff2 = <<"STUFF2";
  [ '$+{post_trans}', sub { $+{rest} }, ],
STUFF2
             $_ = $stuff2;
#==============================================================================
            $i++;
          } elsif (/\(.*(\))\s*,\s*\z/) {
            s/^\s+//;
            s/,\Z//;
            chomp;
            my $temp = $_;
#==============================================================================
             my $stuff3 = <<"STUFF3";
  [ undef, sub { $temp }, ],
STUFF3
	     $_ = $stuff3;
#==============================================================================
            $behaves[$i] = undef;
            $i++;
          } else {
            if (/\s*\),\s*\z/) {
              $_ = "\n";
             }
          }
        }
        if ($found == 0 and /\A1;/) { 
           my $save = $_;

#==============================================================================
           my  $stuff4 = <<"STUFF4";
sub _stEps {
   my (\@steps) =  \@_;
   my (\$rc, \$pos1) = (1, 0);
   try {
     begin_trans();
     my \$rc = 1;
     # do ASSERTs
     while (my (\$j,\$step) = each \@steps) {
       \$pos1 = \$j;
       if ((defined(\$step->[0])) and (\$step->[0] eq 'ASSERT')) {
#         say \$step->[0]; 
	 \$rc = \$step->[1]();
         return if (not (\$rc));   # an ASSERT w/ FALSE return code, runaway
       }
       else { last; }
     }
     my \$pos2;
     # do NO or ALWAYS Behaviors
     for my \$j (\$pos1..\$#steps) {
       \$pos2 = \$j;
       if ( not (defined(\$steps[\$j][0])) ) {
         \$rc = \$steps[\$j][1]();
         last if (not (\$rc));
       } elsif ((defined(\$steps[\$j][0])) and (\$steps[\$j][0] eq 'ALWAYS')) {
         \$rc = \$steps[\$j][1]();
         last if (not (\$rc));
       }
     }
     # have a FALSE return code
     if (not (\$rc)) {
       # hit all FAILUREs, starting where ASSERTs left off
       for my \$j (\$pos1..\$#steps) {
         if ((defined(\$steps[\$j][0])) and (\$steps[\$j][1] eq 'FAILURE')) {
           \$rc = \$steps[\$j][1]();
           # what do you do with a bad return code??
         }
       }
       # find all ALWAYS that were not executed
       # we left off at \$pos2
       \$pos2++;
       for my \$j (\$pos2..\$#steps) {
         if ((defined(\$steps[\$j][0])) and (\$steps[\$j][0] eq 'ALWAYS')) {
           \$rc = \$steps[\$j][1]();
           # what do you do with a bad return code??
         }
       }
     }
     end_trans();
   }
   catch {
     roll_back();
     die \$_; # rethrow
   };
   return 1;
} 
STUFF4
           $_ = "$stuff4\n#end\n" . $save;
#==============================================================================
         }
      }
      $status;  # return status;
    } 
 )
}
1;
