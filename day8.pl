use strict;
use warnings;
use Data::Dumper;

open(my $fh, '<', 'day8.txt') or die "cannot open";
local $/ = undef;

my $textContent = <$fh>;
my @lines = split('\n', $textContent);

sub matrix {
    my $m = [];
    for (my $i = 0; $i < scalar(@lines); $i++) {
        my @line = split(//, $lines[$i]);
        push(@$m, \@line);
    }
    return $m;
}

sub allInferior {
    my ($value, $list) = @_;
    foreach my $item (@$list) {
        if ($item >= $value) {
            return 0;
        }
    }
    return 1;
}

sub visible {
    my ($m, $i, $j) = @_;
    my $height = $m->[$i]->[$j];

    my $lists = [];
    my @line1 = @{@$m[$i]}[0..$j-1];
    my @line2 = @{@$m[$i]}[$j+1..scalar(@{@$m[$i]})-1];
    my @line3 = ();
    my @line4 = ();
    for (my $k = 0; $k < $i; $k++) {push(@line3, $m->[$k]->[$j]);}
    for (my $k = $i+1; $k < scalar(@$m); $k++) {push(@line4, $m->[$k]->[$j]);}
    push(@$lists, \@line1);
    push(@$lists, \@line2);
    push(@$lists, \@line3);
    push(@$lists, \@line4);

    foreach my $list (@$lists) {
        if (allInferior($height, $list)) {
            return 1;
        }
    }
    return 0;

}

sub part1 {
    my $m = matrix();
    my $count = 0;

    for (my $i = 0; $i < scalar(@$m); $i++) {
        for (my $j = 0; $j < scalar(@{@$m[0]}); $j++) {
            if (visible($m, $i, $j)) {
                $count++;
            }

        }
    }

    print "part1: $count\n";

}

sub score {
    my ($m, $i, $j) = @_;
    my $treeScore = 1;
    my $treeHeight = $m->[$i]->[$j];

    my $lists = [];
    my @list1 = ();
    my @list2 = ();
    my @list3 = ();
    my @list4 = ();
    for (my $k = $i-1; $k >= 0; $k--) {push(@list1, $m->[$k]->[$j]);}
    for (my $k = $i+1; $k < scalar(@$m); $k++) {push(@list2, $m->[$k]->[$j]);}
    for (my $k = $j-1; $k >= 0; $k--) {push(@list3, $m->[$i]->[$k]);}
    for (my $k = $j+1; $k < scalar(@{@$m[$i]}); $k++) {push(@list4, $m->[$i]->[$k]);}
    push(@$lists, \@list1);
    push(@$lists, \@list2);
    push(@$lists, \@list3);
    push(@$lists, \@list4);

    foreach my $list (@$lists) {
        my $index = 0;
        my $tallerTreeFound = 0;
        while ($index < scalar(@$list) && not($tallerTreeFound)) {
            if ($list->[$index] >= $treeHeight) {
                $tallerTreeFound = 1;
            }
            $index++;
        }
        $treeScore *= $index;
    }

    return $treeScore;

}

sub part2 {

    my $m = matrix();
    my $max_i = 0;
    my $max_j = 0;
    my $maxScore = score($m, $max_i, $max_j);

    for (my $i = 0; $i < scalar(@$m); $i++) {
        for (my $j = 0; $j < scalar(@{@$m[0]}); $j++) {

            my $score = score($m, $i, $j);
            if ($score > $maxScore) {
                $maxScore = $score;
                $max_i = $i;
                $max_j = $j;
            }

        }
    }

    print "part2: $maxScore\n";

}


part1;
part2;