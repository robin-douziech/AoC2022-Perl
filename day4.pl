use strict;
use warnings;
use Data::Dumper;
use List::Util qw(sum);

open(my $fh, '<', 'day4.txt') or die "cannot open";
local $/ = undef;

my $fileContent = <$fh>;
my @lines = split('\n', $fileContent);

sub getValues {
    my @param = @_;
    my @result = ();

    foreach my $line (@param) {
        my @ranges = split(',', $line);
        push(@result, [split('-', $ranges[0]), split('-', $ranges[1])]);
    }

    return @result;
}

sub part1 {
    my $result = scalar grep {($_->[0]>=$_->[2] && $_->[1]<=$_->[3]) || ($_->[0]<=$_->[2] && $_->[1]>=$_->[3])} getValues(@lines);
    print "part1: $result\n";
}

sub overlaps {
    my ($val1, $val2, $val3, $val4) = @$_;
    if ( $val2 < $val3 || $val1 > $val4 ) {
        return 0; # don't overlap
    } else {
        return 1; # overlaps
    }
}

sub part2 {
    my @result = scalar grep {overlaps($_)} getValues(@lines);
    print "part2: @result\n";
}

part1;
part2;