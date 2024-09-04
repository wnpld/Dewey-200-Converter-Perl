#!/usr/bin/perl
use strict;
use CGI qw(:standard);

my $data;
open(my $fh, '<', '/var/tmp/200sfile.txt') or die &return_error("Error","File Error","Cannot open uploaded file with call number data.");
{
	local $/;
	$data = <$fh>;
}
close($fh);

#Delete the uploaded file
unlink "/var/wwwtemp/200sfile.txt";

#Analyze the data and put it into an array and a hash

#First put each line of the file into an array
my @report_lines = split /\n/, $data;

#Create a record count variable
my $record_count = scalar @report_lines;

#The first line should be a header row.  Analyze it to determine field locations
my @fields = split /\t/, $report_lines[0];

my $classnocol;
my $column_count = scalar @fields;

for (my $x = 0; $x < $column_count; $x++) {
    if ($fields[$x] eq "ClassificationNumber") {
        $classnocol = $x;
        last;
    }
}

if (!defined $classnocol) {
    &return_error("Error","Unexpected Format","The uploaded file either was not a tab-delimited text file or it did not have a column labeled as 'ClassificationNumber'.");
}

#Create a new header row for output
$report_lines[0] = "";
for (my $x = 0; $x < scalar @fields; $x++) {
    if ($x == 0) {
        $report_lines[0] .= $fields[$x];
    } else {
        $report_lines[0] .= "\t" . $fields[$x];
    }
    if ($x == $classnocol) {
        $report_lines[0] .= "\tNewClassificationNumber";
    }
}

#Establish Dewey Classification Mappings in a 2-dimensional array
#First value in each row is a regular expression matching one or more Dewey numbers
#Second value is the replacement string to be used with the sprintf function

my @deweymap = ([qr{^220$},"240"],
[qr{^220\.(\d+)$},'240.%s'],
[qr{^221$},"241"],
[qr{^221\.(\d+)$},'241.%s'],
[qr{^222$},"242"],
[qr{^222\.(\d+)$},'242.%s'],
[qr{^223$},"243"],
[qr{^223\.(\d+)$},'243.%s'],
[qr{^224$},"244"],
[qr{^224\.(\d+)$},'244.%s'],
[qr{^225$},"245"],
[qr{^225\.(\d+)$},'245.%s'],
[qr{^226$},"246"],
[qr{^226\.(\d+)$},'246.%s'],
[qr{^227$},"247"],
[qr{^227\.(\d+)$},'247.%s'],
[qr{^228$},"248"],
[qr{^228\.(\d+)$},'248.%s'],
[qr{^229$},"249"],
[qr{^229\.(\d+)$},'249.%s'],
[qr{^230$},"252"],
[qr{^230\.(\d+)$},'252.%s'],
[qr{^231$},"253"],
[qr{^231\.(\d+)$},'253.%s'],
[qr{^232$},"254"],
[qr{^232\.(\d+)$},'254.%s'],
[qr{^233$},"255"],
[qr{^233\.(\d+)$},'255.%s'],
[qr{^234$},"256"],
[qr{^234\.(\d+)$},'256.%s'],
[qr{^235$},"257"],
[qr{^235\.(\d+)$},'257.%s'],
[qr{^236$},"258"],
[qr{^236\.(\d+)$},'258.%s'],
[qr{^238$},"259.2"],
[qr{^238\.(\d+)$},'259.2%s'],
[qr{^239$},"259.6"],
[qr{^239\.(\d+)$},'259.6%s'],
[qr{^241$},"261"],
[qr{^241\.(\d+)$},'261.%s'],
[qr{^242$},"262"],
[qr{^242\.(\d+)$},'262.%s'],
[qr{^243$},"263.2"],
[qr{^243\.(\d+)$},'263.2%s'],
[qr{^246$},"263.5"],
[qr{^246\.(\d+)$},'263.5%s'],
[qr{^247$},"263.8"],
[qr{^247\.(\d+)$},'263.8%s'],
[qr{^248$},"264.2"],
[qr{^248\.(\d+)$},'264.2%s'],
[qr{^249$},"264.6"],
[qr{^249\.(\d+)$},'264.6%s'],
[qr{^250$},"265.0"],
[qr{^250\.(\d+)$},'265.0%s'],
[qr{^251$},"266"],
[qr{^251\.(\d+)$},'266.%s'],
[qr{^252$},"267"],
[qr{^252\.(\d+)$},'267.%s'],
[qr{^253$},'268.2'],
[qr{^253\.(\d+)$},'268.2%s'],
[qr{^254$},'268.6'],
[qr{^254\.(\d+)$},'268.6%s'],
[qr{^255$},'269.2'],
[qr{^255\.(\d+)$},'269.2%s'],
[qr{^259$},'269.6'],
[qr{^259\.(\d+)$},'269.6%s'],
[qr{^260$},"270"],
[qr{^261$},"271"],
[qr{^261\.(\d+)$},'271.%s'],
[qr{^262$},"272"],
[qr{^262\.(\d+)$},'272.%s'],
[qr{^263$},"273.2"],
[qr{^263\.(\d+)$},'273.2%s'],
[qr{^264$},"273.6"],
[qr{^264\.(\d+)$},'273.6%s'],
[qr{^265$},"274"],
[qr{^265\.(\d+)$},'274.%s'],
[qr{^266$},"275"],
[qr{^266\.(\d+)$},'275.%s'],
[qr{^267$},"276.2"],
[qr{^267\.(\d+)$},'276.2%s'],
[qr{^268$},"276.5"],
[qr{^268\.(\d+)$},'276.5%s'],
[qr{^269$},"276.8"],
[qr{^269\.(\d+)$},'276.8%s'],
[qr{^270$},"277.2"],
[qr{^270\.(\d+)$},'277.2%s'],
[qr{^271$},"277.4"],
[qr{^271\.(\d+)$},'277.4%s'],
[qr{^272$},"277.6"],
[qr{^272\.(\d+)$},'277.6%s'],
[qr{^273$},"277.8"],
[qr{^273\.(\d+)$},'277.8%s'],
[qr{^274$},'278.4'],
[qr{^274\.(\d+)$},'278.4%s'],
[qr{^275$},'278.5'],
[qr{^275\.(\d+)$},'278.5%s'],
[qr{^276$},'278.6'],
[qr{^276\.(\d+)$},'278.6%s'],
[qr{^277$},'278.7'],
[qr{^277\.(\d+)$},'278.7%s'],
[qr{^278$},'278.8'],
[qr{^278\.(\d+)$},'278.8%s'],
[qr{^279$},'278.9'],
[qr{^279\.(\d+)$},'278.9%s'],
[qr{^280$},"279"],
[qr{^280\.(\d+)$},'279.0%s'],
[qr{^281$},"279.1"],
[qr{^281\.(\d+)$},'279.1%s'],
[qr{^282$},"279.2"],
[qr{^282\.(\d+)$},'279.2%s'],
[qr{^283$},"279.3"],
[qr{^283\.(\d+)$},'279.3%s'],
[qr{^284$},"279.4"],
[qr{^284\.(\d+)$},'279.4%s'],
[qr{^285$},"279.5"],
[qr{^285\.(\d+)$},'279.5%s'],
[qr{^286$},"279.6"],
[qr{^286\.(\d+)$},'279.6%s'],
[qr{^287$},"279.7"],
[qr{^287\.(\d+)$},'279.7%s'],
[qr{^289$},"279.9"],
[qr{^289\.(\d+)$},'279.9%s'],
[qr{^292$},"232"],
[qr{^292\.(\d+)$},'232.%s'],
[qr{^293$},"233"],
[qr{^293\.(\d+)$},'233.%s'],
[qr{^294$},"223"],
[qr{^294\.3$},"227"],
[qr{^294\.33$},"227.1"],
[qr{^294\.33(\d+)$},'227.1%s'],
[qr{^294\.34204$},"227.3"],
[qr{^294\.34204(\d+)$},'227.3%s'],
[qr{^294\.34$},"227.5"],
[qr{^294\.342$},"227.5"],
[qr{^294\.3421$},"227.51"],
[qr{^294\.3422$},"227.52"],
[qr{^294\.3423$},"227.53"],
[qr{^294\.343$},"227.7"],
[qr{^294\.343(\d+)$},'227.7%s'],
[qr{^294\.344$},"227.9"],
[qr{^294\.344(\d+)$},'227.9%s'],
[qr{^294\.35$},"228.1"],
[qr{^294\.35(\d+)$},'228.1%s'],
[qr{^294\.36$},"228.3"],
[qr{^294\.36(\d+)$},'228.3%s'],
[qr{^294\.37$},"228.5"],
[qr{^294\.37(\d+)$},'228.5%s'],
[qr{^294\.38$},"228.7"],
[qr{^294\.38(\d+)$},'228.7%s'],
[qr{^294\.39$},"228.9"],
[qr{^294\.39(\d+)$},'228.9%s'],
[qr{^294\.4$},"226"],
[qr{^294\.4(\d+)$},'226.%s'],
[qr{^294\.5$},"223.1"],
[qr{^294\.51$},"223.2"],
[qr{^294\.51(\d+)$},'223.2%s'],
[qr{^294\.52$},"223.5"],
[qr{^294\.52(\d+)$},'223.5%s'],
[qr{^294\.53$},"223.8"],
[qr{^294\.53(\d+)$},'223.8%s'],
[qr{^294\.54$},"224.2"],
[qr{^294\.54(\d+)$},'224.2%s'],
[qr{^294\.55$},"224.6"],
[qr{^294\.55(\d+)$},'224.6%s'],
[qr{^294\.56$},"225.2"],
[qr{^294\.56(\d+)$},'225.2%s'],
[qr{^294\.57$},"225.5"],
[qr{^294\.57(\d+)$},'225.5%s'],
[qr{^294\.59$},"225.8"],
[qr{^294\.59(\d+)$},'225.8%s'],
[qr{^294\.6$},"229"],
[qr{^294\.6(\d+)$},'229.%s'],
[qr{^295$},'235.%s'],
[qr{^296$},"251"],
[qr{^296\.(\d+)$},'251.%s'],
[qr{^297$},"280"],
[qr{^297\.0(\d+)$}, '280.0%s'],
[qr{^297\.12$},"282"],
[qr{^297\.12(\d+)$},'282.%s'],
[qr{^297\.14$},"284"],
[qr{^297\.14(\d+)$},'284.%s'],
[qr{^297\.18$},"288"],
[qr{^297\.18(\d+)$},'288.%s'],
[qr{^297\.2$},"292"],
[qr{^297\.2(\d+)$},'292.%s'],
[qr{^297\.3$},"293"],
[qr{^297\.3(\d+)$},'293.%s'],
[qr{^297\.4$},"294"],
[qr{^297\.4(\d+)$},'294.%s'],
[qr{^297\.5$},"295"],
[qr{^297\.5(\d+)$},'295.%s'],
[qr{^297\.6$},"296"],
[qr{^297\.6(\d+)$},'296.%s'],
[qr{^297\.7$},"297"],
[qr{^297\.7(\d+)$},'297.%s'],
[qr{^297\.8$},"298"],
[qr{^297\.8(\d+)$},'298.%s'],
[qr{^297\.9$},"299.1"],
[qr{^297\.9(\d+)$},'299.1%s'],
[qr{^299\.16$},"231"],
[qr{^299\.16(\d+)$},'231.%s'],
[qr{^299\.17$},"236.7"],
[qr{^299\.17(\d+)$},'236.7%s'],
[qr{^299\.18$},"236.8"],
[qr{^299\.18(\d+)$},'236.8%s'],
[qr{^299\.19$},"236.9"],
[qr{^299\.19(\d+)$},'236.9%s'],
[qr{^299\.2$},"237"],
[qr{^299\.2(\d+)$},'237.%s'],
[qr{^299\.31$},"238"],
[qr{^299\.31(\d+)$},'238.%s'],
[qr{^299\.51$},"221"],
[qr{^299\.511$},"221.1"],
[qr{^299\.511(\d+)$},'221.1%s'],
[qr{^299\.512$},"221.6"],
[qr{^299\.512(\d+)$},'221.6%s'],
[qr{^299\.514$},"221.2"],
[qr{^299\.514(\d+)$},'221.2%s'],
[qr{^299\.54$},"222.2"],
[qr{^299\.56$},"222.4"],
[qr{^299\.561$},"222.5"],
[qr{^299\.561(\d+)$},'222.5%s'],
[qr{^299\.57$},"222.7"],
[qr{^299\.58$},"222.8"],
[qr{^299\.59$},"222.9"],
[qr{^299\.6$},"239.6"],
[qr{^299\.6(\d+)$},'239.6%s'],
[qr{^299\.7$},"239.7"],
[qr{^299\.7(\d+)$},'239.7%s'],
[qr{^299\.8$},"239.8"],
[qr{^299\.8(\d+)$},'239.8%s'],
[qr{^299\.9215$},"239.915"],
[qr{^299\.9215(\d+)$},'239.915%s'],
[qr{^299\.922$},"239.92"],
[qr{^299\.922(\d+)$},'239.92%s'],
[qr{^299\.923$},"239.93"],
[qr{^299\.923(\d+)$},'239.93%s'],
[qr{^299\.924$},"239.94"],
[qr{^299\.924(\d+)$},'239.94%s'],
[qr{^299\.925$},"239.95"],
[qr{^299\.925(\d+)$},'239.95%s'],
[qr{^299\.9292$},"239.22"],
[qr{^299\.9292(\d+)$},'239.22%s'],
[qr{^299\.9293$},"239.23"],
[qr{^299\.9293(\d+)$},'239.23%s'],
[qr{^299\.9294$},"239.24"],
[qr{^299\.9294(\d+)$},'239.24%s'],
[qr{^299\.9295$},"239.25"],
[qr{^299\.9295(\d+)$},'239.25%s'],
[qr{^299\.9296$},"239.26"],
[qr{^299\.9296(\d+)$},'239.26%s'],
[qr{^299\.93$},"299.2"],
[qr{^299\.932$},"239.4"],
[qr{^299\.933$},"299.3"],
[qr{^299\.934$},"299.4"],
[qr{^299\.935$},"299.5"],
[qr{^299\.936$},"299.6"],
[qr{^299\.94$},"299.9"],
[qr{^299\.94(\d+)$},'299.9%s']);

my @newdewey;
for (my $x = 1; $x < $record_count; $x++) {
    my @field_data = split /\t/, $report_lines[$x];
    my $classno = $field_data[$classnocol];
    my $found = 0;
    my $newclassno;
    if ($classno !~ /\d\d\d(\.\d*){0,1}/) {
        $newclassno = "Invalid class number";
    } else {
        for (my $y = 0; $y < scalar @deweymap; $y++) {
            if ($classno =~ /$deweymap[$y][0]/) {
                $found = 1;
                $newclassno = sprintf $deweymap[$y][1], $1;
                last;
            }
        }
        if ($found == 0) {
            $newclassno = "No conversion match";
        }
    }
    #Rewrite the current report line with the new classification number added
    $report_lines[$x] = "";
    for (my $y = 0; $y < scalar @field_data; $y++) {
        if ($y == 0) {
            $report_lines[$x] .= $field_data[$y];
        } else {
            $report_lines[$x] .= "\t" . $field_data[$y];
        }
        if ($classnocol == $y) {
            $report_lines[$x] .= "\t" . $newclassno;
        }
    }
}

my $output = "";
foreach my $line (@report_lines) {
    $output .= "$line\n";
}

{
	use bytes;
	my $byte_size = length($output); 
	print "Content-length: $byte_size\n";
}
print "Content-Type:application/octet-stream\n";
print "Content-Disposition:attachment;filename=200srevised.txt\n\n";
print $output;

exit;

sub return_error
{
    my ($status, $keyword, $message) = @_;
    print "Content-type: text/html", "\n";
    print "Status: ", $status, " ", $keyword, "\n\n";
    print <<End_of_Error;
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<title>Unexpected Processing Error</title>
</head>
<body>
<div class="container">
<h1>$keyword</h1>
<p>$message</p>
<hr>
The above error has occurred.
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>

End_of_Error

exit(1);
}
