use strict;
use warnings;
use Data::Dumper;
use List::Util qw(first);

open(my $fh, '<', 'day13.txt') or die "cannot open";
local $/ = undef;

my $textContent = <$fh>;
my @pairs = split('\n\n', $textContent);

# Transorms a string a packet to the list of its components
# e.g. [1, [2, 3, [4]], [6, []], 7] ---> ("1", "[2, 3, [4]]", "[6, []]", "7")
sub string_to_list {
    my $string = substr($_[0], 1, -1);
    my @result = ();
    my $tmp_string = "";
    my $bracket_counter = 0;
    for (my $i = 0; $i < length($string); $i++) {
        if (substr($string, $i, 1) eq ',') {
            if ($bracket_counter == 0) {
                push(@result, $tmp_string);
                $tmp_string = "";
            } else {
                $tmp_string .= ',';
            }
        } elsif (substr($string, $i, 1) eq '[') {
            $bracket_counter++;
            $tmp_string .= '[';
        } elsif (substr($string, $i, 1) eq ']') {
            $bracket_counter--;
            $tmp_string .= ']';
        } else {
            $tmp_string .= substr($string, $i, 1);
        }
    }
    push(@result, $tmp_string) if length($tmp_string) > 0;
    return \@result;
}

# Compares two packets
#
# returns :
#   -1 if $left < $right
#    0 if $left = $right
#    1 if $left > $right
sub compare {
    my ($left, $right) = @_;
    return 0 if $left eq $right;
    if ($left =~ /^\d+$/ && $right =~ /^\d+$/) {
        return int($left) <=> int($right);
    } elsif ($left =~ /^\[[0-9,\[\]]*\]$/ && $right =~ /^\[[0-9,\[\]]*\]$/) {
        my $result = 0;
        my $index = 0;
        my $left = string_to_list($left);
        my $right = string_to_list($right);
        while ($result == 0) {
            if ($index >= scalar(@$left) && $index < scalar(@$right)) {
                $result = -1;
            } elsif ($index < scalar(@$left) && $index >= scalar(@$right)) {
                $result =  1;
            } elsif ($index >= scalar(@$left) && $index >= scalar(@$right)) {
                last;
            } elsif ($index < scalar(@$left) && $index < scalar(@$right)) {
                $result = compare($left->[$index], $right->[$index]);
            }
            $index++;
        }
        return $result;
    } elsif ($left =~ /^\d+$/ && $right =~ /^\[[0-9,\[\]]*\]$/) {
        return compare("[$left]", $right);
    } elsif ($left =~ /^\[[0-9,\[\]]*\]$/ && $right =~ /^\d+$/) {
        return compare($left, "[$right]");
    }
}

# Inserts a packet in an ordered list of packets
sub insert_packet {

    my ($packet, @packets) = @_;
    my $index = $#packets;
    while ($index >= 0 && compare($packet, $packets[$index]) == -1) {
        $index--;
    }

    my @result;
    if ($index == -1) {
        @result = ($packet, @packets);
    } elsif ($index == $#packets) {
        @result = (@packets, $packet);
    } else {
        @result = (@packets[0..$index], $packet, @packets[$index+1..$#packets]);
    }
    return @result;
}

sub part1 {
    my $result = 0;
    for (my $i = 0; $i < scalar(@pairs); $i++) {
        $result += $i+1 if compare(split('\n', $pairs[$i])) == -1;
    }
    print "part1: $result\n";
}

sub part2 {

    my @packets = ('[[2]]', '[[6]]');
    for my $pair (@pairs) {
        for my $packet (split('\n', $pair)) {
            @packets = insert_packet($packet, @packets);
        }
    }

    my $result = ((first { $packets[$_] eq '[[2]]' } 0..$#packets) + 1) * ((first { $packets[$_] eq '[[6]]' } 0..$#packets) + 1);
    print "part2: $result\n";

}

part1();
part2();