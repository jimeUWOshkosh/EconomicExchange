use strict; use warnings;
package PurchaseClones;
use feature 'say';
use Moo;
use myfilter;
use FSA::Rules;
use Try::Tiny;

has key => (
   is      => 'rw',
   default => undef,
);

sub new_exchange {
   my ($slug,        $slugtxt, 
       $successmsg,  $successmsgtxt,
       $failuresmsg, $failuresmsgtxt,
       $steps_rc) = @_;
   return PurchaseClones->new();
}

sub price { say "\t\t\tPurchaseClones price"; 1 }

sub station_area { say "\t\t\tPurchaseClones station_area"; 1 }

sub attempt { say "\t\t\tAttempt: finish"; 1 }
sub Location  { say "\tLocation ", "# of args: ", scalar(@_); 1};
sub Wallet    { say "\tWallet";    1 };
sub Clone     { say "\tClone";     1 };
sub Stats     { say "\tStats";     1 };
sub Inventory { say "\tInventory"; 1 };
sub Event     { say "\tEvent";     1 };
sub begin_trans {};
sub end_trans {};
sub roll_back {};


sub purchase_clone {
   say 'purchase_clone2';
   my ($self) = @_;
   my $character = "and Irvine";
   my $bet_amount = 1_000_006;
   my $exchange = new_exchange(
      slug            => 'purchase-clone',
      success_message => 'You have purchased a new clone',
      failure_message => 'You could not purchase a new clone',
      Steps(
                  Location( $self      => is_in_area  => 'clonevat'              ),
                  Wallet(   $self      => pay         => $self->price('cloning') ),
                  Clone(    $self      => gestate     => $self->station_area     ),
         FAILURE( Wallet(   $character => remove      => $bet_amount ) ),
         ALWAYS(  Wallet( $character => 'show_balance') ),
      ),
   );
}


sub func1 { say "\tfunc1"; 1 }
sub func2 { say "\tfunc2"; 1 }

sub testeee {
   say 'testee';
  my ($self) = @_;
    
  my $exchange = Steps(
              func1( 0, 1, 2, 3, 4, 5),
       ALWAYS(func2( 0, 1, 2, 3, 4, 5)),
    );
}

1;
