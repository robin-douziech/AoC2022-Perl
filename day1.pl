use strict;
use warnings;
use List::Util qw(sum);

open(my $fh, '<', 'day1.txt') or die "cannot open";
local $/ = undef;

sub main {

    my $fileContent = <$fh>;
    my @elvesCalories = sort map {sum(split('\n', $_))} split('\n\n', $fileContent);
    my $part1 = $elvesCalories[-1];
    my $part2 = $elvesCalories[-1] + $elvesCalories[-2] + $elvesCalories[-3];
    print "part1: $part1\npart2: $part2\n";

}

main;