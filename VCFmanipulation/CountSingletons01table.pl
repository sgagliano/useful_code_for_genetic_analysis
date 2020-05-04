###Print out singleton counts for 2 groups
###Script written by Hyun Min Kang
###Example commands to run:
#convert bcf to sav:
#sav import --index chr10.filtered.gtonly.minDP0.minAC1.bcf chr10.filtered.gtonly.minDP0.minAC1.sav
#time perl CountSingletons01table.pl chr10:115088370-115953983
#example output: 
#        cnt1s	cnts0s	cnt1s/(cnt1s+cnt1s)
#Group1	5468	2287	0.70509
#Group2	4601	1916	0.70600


#!/usr/bin/perl -w

use strict;

my $maxAC = 1;
my $reg = $ARGV[0];
my ($chrom,$beg,$end) = split(/[:-]/,$reg);

my %id2grp = ();
open(IN,"cut -f 1,2 g01.dat | tail -n +2|") || die "Cannot open file\n"; #2 columns from file: IID and "group": Group1 or Group2
while(<IN>) {
    my ($id,$grp) = split;
    $id2grp{$id} = ( $grp eq "Group2" ) ? 1 : 0; #replace with one of the 2 names in "group"
}
close IN;

my $prefix = "$chrom.filtered.gtonly.minDP0.minAC1"; #prefix for sav file
## count "group" labels
my @ids = split(/\s+/,`bcftools view -h $prefix.bcf | tail -1 | cut -f 10-`);
chomp $ids[$#ids];  ## remove trailing whitespaces, if any
my @phes = ();
foreach my $id (@ids) {
    push(@phes,$id2grp{$id});
}
my @burdens = (0) x ($#ids+1);

open(IN,"sav-gen-info export --sites-only --generate-info SPARSE_OFFSETS_GT --filter 'AC <= $maxAC' -r $reg $prefix.sav | grep -v ^# |") || die "Cannot open file\n";
while(<IN>) {
    my @F = split;
    next unless ( $F[6] eq "PASS" );  ## remove failed variants
    next if ( $F[7] =~ /AC=0/ );
    ## next unless ( length($F[3])+length($F[4]) == 2 ); ## remove indels
    ## next unless ( $F[7] =~ /missense_variant/ ); ## only keep missense variant
    ## next unless ( $F[7] =~ /stop_gain/ ); ## only keep missense variant
    my @ivars = split(/,/,$1) if ( $F[7] =~ /SPARSE_OFFSETS_GT=(\S+)/ );
#    open(fh,"$prefix.txt")|| die "Cannot open file\n";
#    print fh ($F[1] $F[2] $F[3] $F[4]);
#    close fh;
#    print "done\n";
    foreach my $i (@ivars) {
	++$burdens[int($i/2)];
    }
}
close IN;

my @names = qw(Group1 Group2); #replace with your "group" names
my @cnt0s = (0,0);
my @cnt1s = (0,0);
for(my $i=0; $i < @ids; ++$i) {
    if ( $burdens[$i] > 0 ) {    
	++$cnt1s[$phes[$i]];
    }
    else {
	++$cnt0s[$phes[$i]];
    }
}

for(my $i=0; $i < @cnt0s; ++$i) {
    print join("\t",$names[$i],$cnt1s[$i],$cnt0s[$i],sprintf("%.5lf",$cnt1s[$i]/($cnt0s[$i]+$cnt1s[$i])))."\n";
}
