# Economic Exchange For Everyone Else

Business State Machine for Transactions
Proof of concept

I made multiple presenations on the progress of this project
at the Madison Perl Mongers (MadMongers) in 2018

Please review the mdp presentation EE.mdp in

Remember in this source filter, each step must be on a single line!!!
If you desire something more accommodating, consider yourself to be
empowered. This is only a proof of concept.

run.pl is a sample program ( $ perl run.pl )

To see filter output
$ perl -d run.pl

Note: That if a step has a subroutine as an argument, it is executed only when 
      the current step/state is under consideration.


main::(run.pl:6):	my $clone = PurchaseClones->new;

  DB<1> n
  
main::(run.pl:7):	$clone->purchase_clone;

DB<2> s

list the code of the lib/PurchaseClones.pm your favorite way

DB<3> | l 1-300


    ├── EE.mdp
    ├── lib
    │   ├── myfilter.pm
    │   ├── PurchaseClones.pm
    │   └── regex-explain.pl
    ├── LICENSE
    ├── prototypes
    │   ├── t10.pl
    │   ├── t5.pl
    │   ├── t8.pl
    │   └── t9.pl
    ├── README.md
    ├── run.pl
    └── templates
        ├── StepsArg.txt
        └── StepsProced.txt

