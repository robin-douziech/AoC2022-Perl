use strict;
use warnings;
use Data::Dumper;
use feature qw(switch);
use List::Util qw(min);

open(my $fh, '<', 'day9.txt') or die "cannot open";
local $/ = undef;

my $textContent = <$fh>;
my @lines = split('\n', $textContent);

# part1
my $rope1 = [
    [0, 0],
    [0, 0]
];

# part2
my $rope2 = [
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0]
];

sub comparePositions {
    my ($pos1, $pos2) = @_;
    if ($pos1->[0] == $pos2->[0] && $pos1->[1] == $pos2->[1]) {
        return 1;
    }
    return 0;
}

sub moveKnot { # (knot, move)
    given($_[1]) {
        when('U')  {$_[0] = [$_[0]->[0]+0, $_[0]->[1]+1];}
        when('R')  {$_[0] = [$_[0]->[0]+1, $_[0]->[1]+0];}
        when('D')  {$_[0] = [$_[0]->[0]+0, $_[0]->[1]-1];}
        when('L')  {$_[0] = [$_[0]->[0]-1, $_[0]->[1]+0];}
        when('UR') {$_[0] = [$_[0]->[0]+1, $_[0]->[1]+1];}
        when('UL') {$_[0] = [$_[0]->[0]-1, $_[0]->[1]+1];}
        when('DR') {$_[0] = [$_[0]->[0]+1, $_[0]->[1]-1];}
        when('DL') {$_[0] = [$_[0]->[0]-1, $_[0]->[1]-1];}
    }
}

sub knotHasToMove { 
    if (abs($_[1]->[0] - $_[0]->[0]) > 1 || abs($_[1]->[1] - $_[0]->[1]) > 1) {
        #print "MOVE !\n";
        return 1;
    } else {
        return 0;
    }
}

sub moveAttachedKnot {
    my $rel_h = [$_[1]->[0] - $_[0]->[0], $_[1]->[1] - $_[0]->[1]];
    if      (comparePositions($rel_h, [0, 2])) { # up
        moveKnot($_[0], 'U');
    } elsif (comparePositions($rel_h, [2, 0])) { # right
        moveKnot($_[0], 'R');
    } elsif (comparePositions($rel_h, [0, -2])) { # down
        moveKnot($_[0], 'D');
    } elsif (comparePositions($rel_h, [-2, 0])) { # left
        moveKnot($_[0], 'L');
    } elsif (comparePositions($rel_h, [-2, 1]) || comparePositions($rel_h, [-1, 2]) || comparePositions($rel_h, [-2, 2])) { # up/left
        moveKnot($_[0], 'UL');
    } elsif (comparePositions($rel_h, [1, 2]) || comparePositions($rel_h, [2, 1]) || comparePositions($rel_h, [2, 2])) { # up/right
        moveKnot($_[0], 'UR');
    } elsif (comparePositions($rel_h, [2, -1]) || comparePositions($rel_h, [1, -2]) || comparePositions($rel_h, [2, -2])) { # down/right
        moveKnot($_[0], 'DR');
    } elsif (comparePositions($rel_h, [-2, -1]) || comparePositions($rel_h, [-1, -2]) || comparePositions($rel_h, [-2, -2])) { # down/left
        moveKnot($_[0], 'DL');
    }
}

sub deleteDuplicatePositions {

    my ($param) = @_;
    my $result = [];

    foreach my $position (@$param) {
        my $key = join(',', @$position);
        if (scalar(grep {$_ eq $key} @$result) == 0) {
            push(@$result, $key);
        }
    }

    return $result;

}

sub part1 {

    my $tailPositions = [[0, 0]];

    foreach my $line (@lines) {
        $line =~ /^([URDL]) (\d+)$/;
        for (my $i = 0; $i < $2; $i++) {
            moveKnot($rope1->[0], $1);
            if (knotHasToMove($rope1->[1], $rope1->[0])) {
                moveAttachedKnot($rope1->[1], $rope1->[0]);
                push(@$tailPositions, $rope1->[1]);
            }
        }
    }

    $tailPositions = deleteDuplicatePositions($tailPositions);
    my $result = scalar(@$tailPositions);
    print "part1: $result\n";

}

sub part2 {

    my $tailPositions = [[0, 0]];

    foreach my $line (@lines) {
        $line =~ /^([URDL]) (\d+)$/;
        for (my $i = 0; $i < $2; $i++) {
            moveKnot($rope2->[0], $1);
            for (my $i = 1; $i < 10; $i++) {
                if (knotHasToMove($rope2->[$i], $rope2->[$i-1])) {
                    moveAttachedKnot($rope2->[$i], $rope2->[$i-1]);
                }
                if ($i == 9) {
                    push(@$tailPositions, $rope2->[9]);
                }
            }
        }

    }

    $tailPositions = deleteDuplicatePositions($tailPositions);
    my $result = scalar(@$tailPositions);
    print "part2: $result\n";

}

part1;
part2;