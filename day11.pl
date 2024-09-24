use strict;
use warnings;
use Data::Dumper;

open(my $fh, '<', 'day11.txt') or die "cannot open";
local $/ = undef;

my $textContent = <$fh>;
my @lines = split('\n', $textContent);

my $monkeys = [];

sub initial_state {
    $monkeys = [];
    foreach my $monkey_text (split('\n\n', $textContent)) {
        $monkey_text =~ /.*Starting items: ([0-9, ]*)\n[ ]*Operation: ([newold+*= 0-9]+)\n[ ]*Test: divisible by (\d+)\n[ ]*If true: throw to monkey (\d+)\n[ ]*If false: throw to monkey (\d+)/;
        my @items = split(', ', $1);
        my $monkey = {
            'items' => \@items,
            'operation' => $2,
            'test' => $3,
            'true' => $4,
            'false' => $5,
            'inspection_number' => 0
        };
        push(@$monkeys, \%$monkey);
    }
}

sub operation {
    my ($operation, $old, ) = @_;
    $operation =~ /^new = (old|\d+) (\*|\+) (old|\d+)$/;

    my $operand1 = ($1 eq 'old') ? $old : $1;
    my $operand2 = ($3 eq 'old') ? $old : $3;
    if ($2 eq '*') {
        return $operand1 * $operand2;
    } else {
        return $operand1 + $operand2;
    }
}

sub throwItemToMonkey {
    my ($src_monkey_num, $dst_monkey_num) = @_;
    my $src_monkey = $monkeys->[$src_monkey_num];
    my $dst_monkey = $monkeys->[$dst_monkey_num];
    my @dst_items = ($src_monkey->{'items'}->[0], @{ $dst_monkey->{'items'} });
    my @src_items = @{ $src_monkey->{'items'} }[1..scalar(@{ $src_monkey->{'items'} })-1];
    $src_monkey->{'items'} = \@src_items;
    $dst_monkey->{'items'} = \@dst_items;
}

sub process_item {
    my ($monkey_number, $part) = @_;
    my $monkey = $monkeys->[$monkey_number];
    $monkey->{'inspection_number'} = $monkey->{'inspection_number'} + 1;

    # initial value
    my $item = $monkey->{'items'}->[0];

    # operation
    $item = operation($monkey->{'operation'}, $item);

    # //3
    if ($part == 1) {
        $item = int($item/3);
    } else {
        $item %= 7*2*19*3*13*11*5*17;
    }

    $monkey->{'items'}->[0] = $item;

    # test
    if ($item % $monkey->{'test'} == 0) {
        throwItemToMonkey($monkey_number, $monkey->{'true'});
    } else {
        throwItemToMonkey($monkey_number, $monkey->{'false'});
    }

}

sub round {

    my ($part) = @_;

    for (my $i = 0; $i < scalar(@$monkeys); $i++) {
        while (scalar(@{$monkeys->[$i]->{'items'}}) > 0) {
            process_item($i, $part);
        }
    }

}

sub findTwoMostActiveMonkeys {
    my $first = $monkeys->[0];
    my $second = undef;
    for (my $i = 1; $i < scalar(@$monkeys); $i++) {
        if ($monkeys->[$i]->{'inspection_number'} > $first->{'inspection_number'}) {
            $second = $first;
            $first = $monkeys->[$i];
        } elsif (not(defined($second)) || $monkeys->[$i]->{'inspection_number'} > $second->{'inspection_number'}) {
            $second = $monkeys->[$i];
        }
    }
    return ($first, $second);
}

sub main {

    initial_state;

    for (my $i = 0; $i < 20; $i++) {
        round(1);
    }

    my ($first, $second) = findTwoMostActiveMonkeys();

    my $result = $first->{'inspection_number'} * $second->{'inspection_number'};
    print "part1: $result\n";

    initial_state;

    for (my $i = 0; $i < 10000; $i++) {
        round(2);
    }

    my ($first, $second) = findTwoMostActiveMonkeys();

    my $result = $first->{'inspection_number'} * $second->{'inspection_number'};
    print "result: $result\n";

}

main;