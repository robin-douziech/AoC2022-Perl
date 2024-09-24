use strict;
use warnings;
use Data::Dumper;

open(my $fh, '<', 'day7.txt') or die "cannot open";
local $/ = undef;

my $textContent = <$fh>;
my @lines = split('\n', $textContent);

sub cd {
    my ($wd, $arg) = @_;
    if ($arg eq '/') {
        $wd = '';
    } elsif ($arg eq '..') {
        $wd = substr($wd, 0, rindex($wd, '/'));
    } else {
        $wd .= "/$arg";
    }
    return $wd;
}

sub main {

    my $file_system = {};
    my $work_dir = '';
    my @known_files = ();
    my @known_dirs = ('/');
    my $index = 0;
    while ($index < scalar(@lines)) {
        if ($lines[$index] =~ /\$ cd (.+)/) {
            $work_dir = cd($work_dir, $1);
        } elsif ($lines[$index] =~ /\$ ls/) {
            while ($index + 1 < scalar @lines && $lines[$index+1] !~ /^\$/) {
                if ($lines[$index+1] =~ /^dir (.+)$/) {
                    if (scalar(grep {$_ eq "$work_dir/$1"} @known_dirs) == 0) {
                        push(@known_dirs, "$work_dir/$1");
                    }
                } elsif ($lines[$index+1] =~ /^(\d+) (.+)$/) {
                    if (scalar(grep {$_ eq "$work_dir/$2 $1"} @known_files) == 0) {
                        push(@known_files, "$work_dir/$2 $1");
                    }
                }
                $index++;
            }
        }
        $index++;
    }

    my %dirWeight = ();
    for my $dir (@known_dirs) {
        $dirWeight{$dir} = 0;
    }

    foreach my $file (@known_files) {
        $file =~ /([^ ]+) (\d+)$/;
        foreach my $dir (@known_dirs) {
            if (substr($1, 0, length($dir)) eq $dir) {
                $dirWeight{$dir} += $2;
            }
        }
    }

    my $sum = 0;
    foreach my $dir (@known_dirs) {
        if ($dirWeight{$dir} < 100000) {
            $sum += $dirWeight{$dir};
        }
    }

    print "part1: $sum\n";

    my $freeSpace = 70000000 - $dirWeight{'/'};
    my $treshold = 30000000 - $freeSpace;

    my @bigEnoughDirs = ();
    foreach my $dir (@known_dirs) {
        if ($dirWeight{$dir} >= $treshold) {
            push(@bigEnoughDirs, $dir);
        }
    }
    my $minWeightDir = $bigEnoughDirs[0];
    my $minWeight = $dirWeight{$minWeightDir};
    foreach my $dir (@bigEnoughDirs[1..scalar(@bigEnoughDirs)-1]) {
        if ($dirWeight{$dir} < $minWeight) {
            $minWeightDir = $dir;
            $minWeight = $dirWeight{$dir};
        }
    }

    print "part2: $minWeight\n";

}

main;