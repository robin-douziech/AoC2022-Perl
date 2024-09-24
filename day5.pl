use strict;
use warnings;
use Data::Dumper;

open(my $fh, '<', 'day5.txt') or die "cannot open";
local $/ = undef;

my $textContent = <$fh>;
my @lines = split('\n', $textContent);
my ($numbersLineIndex) = grep { $lines[$_] =~ /(\d+)\s*$/ } 0..$#lines;

sub getStacks {

    my $numbersLine = $lines[$numbersLineIndex];
    my $stackNumber = $numbersLine =~ /(\d+)\s*$/;
    $stackNumber = $1;

    my $stacks = [];
    for (my $i = 0; $i < $stackNumber; $i++) {
        my $stack = [];
        for (my $j = $numbersLineIndex-1; $j >= 0; $j--) {
            if (substr($lines[$j], 1+4*$i, 1) =~ /[A-Z]/) {
                push(@$stack, substr($lines[$j], 1+4*$i, 1));
            }
        }
        push(@$stacks, $stack);
    }
    return $stacks;    
}

sub getTopCrates {
    my ($param) = @_;
    my $result = '';
    for (my $i = 0; $i < scalar @$param; $i++) {
        $result .= @$param[$i]->[-1];
    }
    return $result;
}

sub processLinePart1 {

    my ($param, $stacks) = @_;
    my @numbers = ();
    while ($param =~ /(\d+)/g) {
        push(@numbers, $1);
    }
    my $fromStack = @$stacks[$numbers[1]-1];
    my $toStack = @$stacks[$numbers[2]-1];
    for (my $i = 0; $i < $numbers[0]; $i++) {
        my $crate = pop(@$fromStack);
        push(@$toStack, $crate);
    }

    my $newStacks = [];
    for (my $i = 0; $i < scalar @$stacks; $i++) {
        if ($i == $numbers[1]-1) {
            push(@$newStacks, $fromStack);
        } elsif ($i == $numbers[2]-1) {
            push(@$newStacks, $toStack);
        } else {
            push(@$newStacks, @$stacks[$i]);
        }
    }

    return $newStacks;

}

sub processLinePart2 {

    my ($param, $stacks) = @_;
    my @numbers = ();
    while ($param =~ /(\d+)/g) {
        push(@numbers, $1);
    }
    my $fromStack = @$stacks[$numbers[1]-1];
    my $toStack = @$stacks[$numbers[2]-1];

    my $subStack = [];
    for (my $i = 0; $i < $numbers[0]; $i++) {
        push(@$subStack, pop(@$fromStack));
    }
    while (scalar @$subStack > 0) {
        push(@$toStack, pop(@$subStack));
    }

    my $newStacks = [];
    for (my $i = 0; $i < scalar @$stacks; $i++) {
        if ($i == $numbers[1]-1) {
            push(@$newStacks, $fromStack);
        } elsif ($i == $numbers[2]-1) {
            push(@$newStacks, $toStack);
        } else {
            push(@$newStacks, @$stacks[$i]);
        }
    }

    return $newStacks;

}

sub part1 {

    my $stacks = getStacks;
    for (my $i = $numbersLineIndex+2; $i < scalar @lines; $i++) {
        $stacks = processLinePart1($lines[$i], $stacks);
    }
    my $result = getTopCrates($stacks);
    print "part1: $result\n";

}

sub part2 {

    my $stacks = getStacks;
    for (my $i = $numbersLineIndex+2; $i < scalar @lines; $i++) {
        $stacks = processLinePart2($lines[$i], $stacks);
    }
    my $result = getTopCrates($stacks);
    print "part2: $result\n";

}

part1;
part2;