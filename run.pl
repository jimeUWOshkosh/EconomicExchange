#!/usr/bin/env perl
use strict; use warnings; use feature 'say';
use lib 'lib';
use PurchaseClones;

my $clone = PurchaseClones->new;
$clone->purchase_clone;
say '';
$clone->testeee;
exit 0;
