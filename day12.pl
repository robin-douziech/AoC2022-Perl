use strict;
use warnings;
use Data::Dumper;
use List::PriorityQueue;
use List::Util qw(min); 

open(my $fh, '<', 'day12.txt') or die "cannot open";
local $/ = undef;

my $textContent = <$fh>;
my @lines = split('\n', $textContent);

sub dijkstra {
    my ($graph, $start) = @_;
    
    # Initialisation des distances et du précédent
    my %distances = map { $_ => 'inf' } keys %$graph;
    $distances{$start} = 0;
    
    my %previous;
    
    # Utilisation d'une file de priorité pour explorer les nœuds
    my $pq = List::PriorityQueue->new();
    $pq->insert($start, 0);
    
    while (defined(my $current_node = $pq->pop())) {
        
        # Parcours des voisins
        foreach my $neighbor (keys %{$graph->{$current_node}}) {
            my $weight = $graph->{$current_node}->{$neighbor};
            my $distance = $distances{$current_node} + $weight;
            
            # Si un chemin plus court est trouvé
            if ($distance < $distances{$neighbor}) {
                $distances{$neighbor} = $distance;
                $previous{$neighbor} = $current_node;
                $pq->insert($neighbor, $distance);
            }
        }
    }
    
    return %distances;
}

sub build_map {
    my $S;
    my $E;
    my $map = [];
    my @lines_copy = @lines;
    for (my $i = 0; $i < scalar(@lines_copy); $i++) {
        if ($lines_copy[$i] =~ /S/) {
            my $j = index($lines_copy[$i], 'S');
            $S = "$i;$j;1";
            $lines_copy[$i] =~ s/S/a/;
        }
        if ($lines_copy[$i] =~ /E/) {
            my $j = index($lines_copy[$i], 'E');
            $E = "$i;$j;26";
            $lines_copy[$i] =~ s/E/z/;
        }
        my @list = map { ord($_) - ord('a') + 1 } split(//, $lines_copy[$i]);
        push(@$map, \@list);
    }
    return ($map, $S, $E);
}

sub build_graph {

    my ($part) = @_;

    my ($map, $S, $E) = build_map();
    my $graph = {};

    my $mapHeight = scalar(@$map);
    my $mapWidth = scalar(@{@$map[0]});

    for (my $i = 0; $i < $mapHeight; $i++) {
        for (my $j = 0; $j < $mapWidth; $j++) {
            $graph->{"$i;$j;$map->[$i]->[$j]"} = {};
            my $neighbors = [[$i-1, $j], [$i+1, $j], [$i, $j-1], [$i, $j+1]];
            for my $node (@$neighbors) {
                if ($node->[0] >= 0 && $node->[0] < $mapHeight
                 && $node->[1] >= 0 && $node->[1] < $mapWidth
                 && (($part == 1 && $map->[$node->[0]]->[$node->[1]] <= $map->[$i]->[$j] + 1)
                 ||  ($part == 2 && $map->[$node->[0]]->[$node->[1]] >= $map->[$i]->[$j] - 1))) {
                    $graph->{"$i;$j;$map->[$i]->[$j]"}->{"$node->[0];$node->[1];$map->[$node->[0]]->[$node->[1]]"} = 1;
                }
            }
        }
    }
    return ($graph, $S, $E);
}

sub part1 {
    my ($graph, $S, $E) = build_graph(1);
    my %distances = dijkstra($graph, $S);
    print "part1: $distances{$E}\n";
}

sub part2 {
    my ($graph, $S, $E) = build_graph(2);
    my %distances = dijkstra($graph, $E);
    my @nodes = grep { $_ =~ /\d+;\d+;1$/ } keys %$graph;
    my $result = min(map { $distances{$_} } @nodes);
    print "part2: $result\n";
}

part1;
part2;