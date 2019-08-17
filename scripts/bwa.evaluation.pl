my($genome,$samcount,$depthcount,$out) = @ARGV;
open OUT,">$out"||die;

# reads mapped
#my $line1=&reads_count($samcount,1);
my $line3=&reads_count($samcount,5);
#my $reads_total=(split(/\s/,$line1))[0];
#my $reads_mapped=(split(/\s/,$line3))[0];
my $reads_map_per=(split(/\:/,(split(/\(/,$line3))[1]))[0];

# genome length
my $genome_len=&genome_len($genome);

# sequence depth
my ($coverage,$depth_all)=&depth_count($depthcount,1);
my ($coverage_4x,$depth_4x)=&depth_count($depthcount,4);
my ($coverage_10x,$depth_10x)=&depth_count($depthcount,10);
my ($coverage_20x,$depth_20x)=&depth_count($depthcount,20);

# Result
my $ref=(split(/\./,(split(/\//,$genome))[-1]))[0];
$ref=~s/\.fna//;
my $sample=(split(/\./,(split(/\//,$samcount))[-1]))[0];
my $depth_avg=sprintf "%.2f",$depth_all/$genome_len;
my $coverage_per=sprintf "%.2f",100*$coverage/$genome_len;
my $coverage_per_4x=sprintf "%.2f",100*$coverage_4x/$genome_len;
my $coverage_per_10x=sprintf "%.2f",100*$coverage_10x/$genome_len;
my $coverage_per_20x=sprintf "%.2f",100*$coverage_20x/$genome_len;
print OUT "Ref_genome\tSample\tReads_mapped\tDepth_avg(X)\tCoverage(%)\tCoverage_4X(%)\tCoverage_10X(%)\tCoverage_20X(%)\n";
print OUT "$ref\t$sample\t$reads_map_per\t$depth_avg\t$coverage_per\t$coverage_per_4x\t$coverage_per_10x\t$coverage_per_20x\n";
#print "genome:$genome_len\n";
#print "coverage:$coverage\n";

###################

sub depth_count{
    my ($file,$i) = @_;
    open IN,$file||die;
    my ($count,$sum);
    while(<IN>){
        chomp;
        my @arr=split(/\t/);
        if($arr[2]>=$i){
            $count += 1;
            $sum += $arr[2];
        }
    }
    return ($count,$sum);
    close IN;
}

sub genome_len{
    my $file = shift;
    open IN,$file||die;
    $/="\>";<IN>;
    my $len;
    while(<IN>){
        next unless (my ($id,$seq) = /(.*?)\n(.*)/s);
        $len += ($seq=~ tr/ATCGatcg/ATCGatcg/);
    }
    $/="\n";
    return $len;
    close IN;
}
sub reads_count{
    my($file,$i) = @_;
    open IN, $file || die;
    my $info;
    my $count;
    while(<IN>){
        chomp;
        $count ++;
        if($count == $i){
            $info = $_;
        }
    }
    return $info;
    close IN;
}