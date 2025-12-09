#!/usr/bin/perl
 
use strict;
use warnings;
 
use feature         qw(say);
use List::AllUtils  qw(max min minmax);
 
use Data::Dumper;
$Data::Dumper::Terse = 1;
$Data::Dumper::Indent = 0;
$| = 1;
 
my @input = map { chomp; [map {int} split /,/] } <>;
 
my $dim = int($input[0][1] == $input[1][1]);
 
my %horz;
my %vert;
my @lines;
 
for (my $i = -1; $i < $#input; $i++) {
    my @x = minmax ($input[$i][0], $input[$i+1][0]);
    my @y = minmax ($input[$i][1], $input[$i+1][1]);
 
    push( @lines, [[$x[0],$y[0]], [$x[1],$y[1]]] );
 
    if (($i % 2 == 0) xor $dim) {
        push( $vert{$input[$i][0]}->@*, @y );
    } else {
        push( $horz{$input[$i][1]}->@*, @x );
    }
}
 
my @vertKeys = sort {$a<=>$b} keys %vert;
 
sub inside {
    my @pt = @_;
    my $cross = 0;
 
    return (1) if (exists $horz{$pt[1]} and ($horz{$pt[1]}[0] <= $pt[0] <= $horz{$pt[1]}[1]));
    return (1) if (exists $vert{$pt[0]} and ($vert{$pt[0]}[0] <= $pt[1] <= $vert{$pt[0]}[1]));
 
    foreach my $x (@vertKeys) {
        return ($cross % 2) if ($x > $pt[0]);
 
        if ($vert{$x}[0] < $pt[1] < $vert{$x}[1]) {
            $cross++;
 
        } elsif ($vert{$x}[0] == $pt[1]) {
            my @hline = $horz{$pt[1]}->@*;
            my $other = ($hline[0] != $pt[0]) ? $hline[0] : $hline[1];
            $cross-- if ($vert{$other}[0] == $pt[1]);
 
        } elsif ($vert{$x}[1] == $pt[1]) {
            my @hline = $horz{$pt[1]}->@*;
            my $other = ($hline[0] != $pt[0]) ? $hline[0] : $hline[1];
            $cross-- if ($vert{$other}[1] == $pt[1]);
        }
    }
 
    return ($cross % 2);
}
 
my $part1 = 0;
my $part2 = 0;
for (my $i = 1; $i < @input; $i++) {
    BOX:
    for (my $j = $i - 1; $j < @input; $j++) {
        my $area = (abs($input[$i][0] - $input[$j][0]) + 1)
                 * (abs($input[$i][1] - $input[$j][1]) + 1);
 
        $part1 = max ($area, $part1);
 
        next if ($area < $part2);
        next if (!&inside($input[$i][0], $input[$j][1]) or !&inside($input[$j][0], $input[$i][1]));
 
        my @x = minmax ($input[$i][0], $input[$j][0]);
        my @y = minmax ($input[$i][1], $input[$j][1]);
        my @rect = ([$x[0]+1, $y[0]+1], [$x[1]-1, $y[1]-1]);
 
        foreach my $line (@lines) {
            my @inter = ([max ($rect[0][0], $line->[0][0]), max ($rect[0][1], $line->[0][1])],
                         [min ($rect[1][0], $line->[1][0]), min ($rect[1][1], $line->[1][1])]);
            next BOX if ($inter[0][0] <= $inter[1][0] and $inter[0][1] <= $inter[1][1]);
        }
 
        if ($area > $part2) {
            say "[$area] ", Dumper( $input[$i] ), " ", Dumper( $input[$j] );
            $part2 = $area;
        }
    }
}
 
say "Part 1: $part1";
say "Part 2: $part2";