use strict;
use warnings;
use List::Util qw(sum);

open(my $fh, '<', 'day2.txt') or die "cannot open";
local $/ = undef;

my $fileContent = <$fh>;
$fileContent =~ s/X/A/g;
$fileContent =~ s/Y/B/g;
$fileContent =~ s/Z/C/g;

my $score = {'A' => 1, 'B' => 2, 'C' => 3};
my $win  = {'A' => 'C', 'B' => 'A', 'C' => 'B'};
my $draw = {'A' => 'A', 'B' => 'B', 'C' => 'C'};
my $lose = {'A' => 'B', 'B' => 'C', 'C' => 'A'};

sub calculateScore {

    my @lines = @_;

    my $result = sum map {$score->{substr($_, 2, 1)}} @lines;
    $result += 3 * scalar grep {$draw->{substr($_, 2, 1)} eq substr($_, 0, 1)} @lines;
    $result += 6 * scalar grep {$win->{substr($_, 2, 1)} eq substr($_, 0, 1)} @lines;

    return $result;

}

sub part1 {

    my @lines = split('\n', $fileContent);
    my $result = calculateScore(@lines);
    print "part1: $result\n";

}

sub newValue {

    my ($param) = @_;
    if (substr($param, 2, 1) eq 'A') {
        return substr($param, 0, 2) . $win->{substr($param, 0, 1)};
    } elsif (substr($param, 2, 1) eq 'B') {
        return substr($param, 0, 2) . $draw->{substr($param, 0, 1)};
    } elsif (substr($param, 2, 1) eq 'C') {
        return substr($param, 0, 2) . $lose->{substr($param, 0, 1)};
    }

}

sub part2 {

    my @lines = map {newValue($_)} split('\n', $fileContent);
    my $result = calculateScore(@lines);
    print "part2: $result\n";

}

part1;
part2;