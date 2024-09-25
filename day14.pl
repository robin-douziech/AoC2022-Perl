use strict;
use warnings;
use List::Util qw(min);
use List::Util qw(max);

open(my $fh, '<', 'day14.txt') or die "cannot open";
local $/ = undef;

my $textContent = <$fh>;
my @lines = split('\n', $textContent);

sub print_scan {
    my ($scan) = @_;
    my $result = "";
    for (my $i = 0; $i < scalar(@$scan); $i++) {
        $result .= join('', @{@$scan[$i]});
        $result .= "\n";
    }
    return $result."\n";
}

sub scan {

    # search appropriate slice dimensions
    my $max_x = 500;
    my $max_y = 0;
    for my $line (@lines) {
        for my $point (split(' -> ', $line)) {
            my ($x, $y) = split(',', $point);
            $max_x = $x if $x > $max_x;
            $max_y = $y if $y > $max_y;
        }
    }

    # build an empty slice with appropriate dimensions
    my $slice = [];
    for (my $y = 0; $y < $max_y + 1; $y++) {
        my @line;
        for (my $x = 0; $x < $max_x + 1; $x++) {
            push(@line, '.');
        }
        push(@$slice, \@line);
    }

    # fill the slice with rock cells
    for my $line (@lines) {
        my @points = split(' -> ', $line);
        for (my $i = 1; $i < scalar(@points); $i++) {
            my ($x_old, $y_old) = split(',', $points[$i-1]);
            my ($x_new, $y_new) = split(',', $points[$i]);
            if ($x_new eq $x_old) {
                for (my $y = min($y_new, $y_old); $y <= max($y_new, $y_old); $y++) {
                    $slice->[$y]->[$x_new] = '#';
                }
            } elsif ($y_new eq $y_old) {
                for (my $x = min($x_new, $x_old); $x <= max($x_new, $x_old); $x++) {
                    $slice->[$y_new]->[$x] = '#';
                }
            }
        }
    }

    return $slice;

}

sub sand_fall1 {

    my ($sand_pos, $sand_count, $slice) = @_;
    my ($x, $y) = split(',', $sand_pos);

    if ($y >= scalar(@$slice)-1 || $x == 0 || ($x == scalar(@$slice[0]) && $slice->[$y+1]->[$x] eq '#' && $slice->[$y+1]->[$x-1] eq '#')) {

        return $sand_count;

    } else {

        if ($slice->[$y+1]->[$x] ne '#') {
            $y++;
        } elsif ($slice->[$y+1]->[$x-1] ne '#') {
            $x--;
            $y++;
        } elsif ($slice->[$y+1]->[$x+1] ne '#') {
            $x++;
            $y++;
        } else {
            $slice->[$y]->[$x] = '#';
            $sand_count++;
            $x = 500;
            $y = 0;
        }

        sand_fall1("$x,$y", $sand_count, $slice);

    }

}

# Utility function for part2.
# Probably works but too deep recursion -> process killed
# I try another method -> sand_fall3
sub sand_fall2 {

    my ($sand_pos, $sand_count, $slice, $sand_origin) = @_;
    my ($x_origin, $y_origin) = split(',', $sand_origin);
    my ($x, $y) = split(',', $sand_pos);

    if ($x == 0) {
        $x_origin++;
        $sand_origin = "$x_origin,$y_origin";
        for (my $i = 0; $i < scalar(@$slice); $i++) {
            unshift(@{@$slice[$i]}, '.');
        }
    } elsif ($x == scalar(@{@$slice[0]})-1) {
        for (my $i = 0; $i < scalar(@$slice); $i++) {
            push(@{@$slice[$i]}, '.');
        }
    }

    if ($slice->[$y_origin]->[$x_origin] eq '#') {

        return $sand_count;

    } else {

        if ($y == scalar(@$slice)-1) {
            $slice->[$y]->[$x] = '#';
            ($x, $y) = split(',', $sand_origin);
            $sand_count++;
        } elsif ($y < scalar(@$slice)-1) {
            if ($slice->[$y+1]->[$x] ne '#') {
                $y++;
            } elsif ($slice->[$y+1]->[$x-1] ne '#') {
                $x--;
                $y++;
            } elsif ($slice->[$y+1]->[$x+1] ne '#') {
                $x++;
                $y++;
            } else {
                $slice->[$y]->[$x] = '#';
                ($x, $y) = split(',', $sand_origin);
                $sand_count++;
                print(print_scan($slice));
            }
        }

        sand_fall2("$x,$y", $sand_count, $slice, $sand_origin);

    }

}

sub sand_fall2bis {

    my ($sand_origin, $slice) = @_;
    my ($x_origin, $y_origin) = split(',', $sand_origin);

    my $max_x = $x_origin + scalar(@$slice) - $y_origin;
    if ($max_x > scalar(@{@$slice[0]})) {
        for (my $i = scalar(@{@$slice[0]}); $i <= $max_x; $i++) {
            for (my $j = 0; $j < scalar(@$slice); $j++) {
                push(@{@$slice[$j]}, '.');
            }
        }
    }

    my $counter = 1;
    for (my $y = 1; $y < scalar(@$slice) - $y_origin; $y++) {
        for (my $x = $x_origin - $y; $x <= $x_origin + $y; $x++) {
            if ($slice->[$y]->[$x] eq '.' && not($slice->[$y-1]->[$x-1] eq '#' && $slice->[$y-1]->[$x] eq '#' && $slice->[$y-1]->[$x+1] eq '#')) {
                $counter++;
            } else {
                $slice->[$y]->[$x] = '#';

            }
        }
    }

    return $counter;

}


sub part1 {
    my $slice = scan();
    my $result = sand_fall1("500,0", 0, $slice);
    print "part1: $result\n";
}

sub part2 {
    my $slice = scan();
    my @line = map {'.'} @{$slice->[0]};
    push(@$slice, \@line);
    my $result = sand_fall2bis("500,0", $slice);
    print "part2: $result\n";
}

part1();
part2();