use strict;
use warnings;
use Data::Dumper;

open(my $fh, '<', 'day6.txt') or die "cannot open";
local $/ = undef;

my $textContent = <$fh>;

sub allDifferent {

    my $number = $_[0];
    my @param = split(//, $_[1]);
    my $length = scalar @param;
    for (my $i = 0; $i < $number; $i++) {
        for (my $j = 0; $j < $number; $j++) {
            if ($i != $j && $param[$length - $i - 1] eq $param[$length - $j - 1]) {
                return 0;
            }
        }
    }
    return 1;

}

sub part1 {

    my $length = 4;
    while ($length < length($textContent) && not(allDifferent(4, substr($textContent, 0, $length)))) {
        $length++;
    }
    print "part1: $length\n";

}

sub part2 {

    my $length = 4;
    while ($length < length($textContent) && not(allDifferent(14, substr($textContent, 0, $length)))) {
        $length++;
    }
    print "part2: $length\n";
    
}

part1;
part2;