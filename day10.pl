use strict;
use warnings;
use Data::Dumper;

open(my $fh, '<', 'day10.txt') or die "cannot open";
local $/ = undef;

my $textContent = <$fh>;
my @lines = split('\n', $textContent);

my $strenght = 0;
my $cycleNum = 0;
my $X = 1;

sub incrementCycleNum {
    if (abs($cycleNum % 40 - $X) > 1) {
        print ".";
    } else {
        print "#";
    }
    $cycleNum++;
    if ($cycleNum % 40 == 20) {
        $strenght += $cycleNum*$X;
    }
    if ($cycleNum % 40 == 0) {
        print "\n";
    }
}

sub addx {
    my ($param) = @_;
    incrementCycleNum();
    incrementCycleNum();
    $X += $param;
}

sub noop {
    incrementCycleNum();
}

sub part1 {

    foreach my $line (@lines) {
        $line =~ /^(noop|addx)[ ]{0,1}([-]{0,1}\d+){0,1}$/;
        if ($1 eq 'addx') {
            addx($2);
        } elsif ($1 eq 'noop') {
            noop();
        }
    }

    print "part1: $strenght\n";

}

part1;