#!/usr/bin/perl -w

use strict;
use CGI;
use CGI::Carp qw ( fatalsToBrowser );
use File::Basename;
use utf8;

$CGI::POST_MAX = 1024 * 5000;
my $safe_filename_characters = "a-zA-Z0-9_.-";
my $upload_dir = "./upload/";

my $query = new CGI;
my $filename = $query->param("photo");

if ( !$filename )
{ print $query->header ( ); print "Error: Upload File."; exit; }

my ( $name, $path, $extension ) = fileparse ( $filename, qr/\.[^.]*/ );
$filename = $name . $extension;
$filename =~ tr/ /_/;
$filename =~ s/[^$safe_filename_characters]//g;

if ( $filename =~ /^([$safe_filename_characters]+)$/ )
{ $filename = $1; } else { die "Filename contains invalid characters"; }

my $upload_filehandle = $query->upload("photo");
open ( UPLOADFILE, ">$upload_dir/$filename" ) or die "$!";
binmode UPLOADFILE;
while (<$upload_filehandle>){ print UPLOADFILE; }
close UPLOADFILE;

`/home/eexp/bin/flow.pl "$upload_dir/$filename"`;

print $query->header ( );
print <<END_HTML;
<title>FlowChat</title>
#<title>流程图</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<style type="text/css">
img {border: none;}
</style>
</head>
<body>
<p><img src="$upload_dir/$name.dot.svg" width="80%" /></p>
</body>
</html>
END_HTML

