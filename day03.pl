use strict;
use warnings;
use Data::Dumper;
use List::Util qw(sum);

open(my $fh, '<', 'day3.txt') or die "cannot open";
local $/ = undef;

my $fileContent = <$fh>;
my @lines = split('\n', $fileContent);

sub priority {
    my ($c) = @_;
    if ($c =~ /[a-z]/) {
        return ord($c) - 96;
    } elsif ($c =~ /[A-Z]/) {
        return ord($c) - 38;
    }
}

sub findCommonCharacter {
    my @strings = @_;
    foreach my $c (split(//, $strings[0])) {

        my $isCommon = 1;
        foreach my $str (@strings[1..$#strings]) {
            if (not($str =~ /$c/)) {
                $isCommon = 0;
            }
        }

        if ($isCommon) {
            return $c;
        }

    }
    die "No common character found";
}

sub splitLine {
    my ($line) = @_;
    return (substr($line, 0, length($line)/2), substr($line, length($line)/2, length($line)));
}

sub part1 {

    my $result = sum map {priority(findCommonCharacter(splitLine($_)))} @lines;
    print "part1: $result\n";

}

sub groupLinesBy3 {
    my @param = @_;
    my @result = ();
    for (my $i = 0; $i < $#param; $i += 3) {
        push(@result, "$param[$i]\n$param[$i+1]\n$param[$i+2]\n");
    }
    return @result;
}

sub part2 {

    my $result = sum map {priority(findCommonCharacter(split('\n', $_)))} groupLinesBy3(@lines);
    print "part2: $result\n";

}

part1;
part2;