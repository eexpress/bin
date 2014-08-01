#!/usr/bin/perl -wT

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
my $email_address = $query->param("email_address");

if ( !$filename )
{
print $query->header ( );
print "There was a problem uploading your photo (try a smaller file).";
exit;
}

my ( $name, $path, $extension ) = fileparse ( $filename, '..*' );
$filename = $name . $extension;
$filename =~ tr/ /_/;
$filename =~ s/[^$safe_filename_characters]//g;

if ( $filename =~ /^([$safe_filename_characters]+)$/ )
{
$filename = $1;
}
else
{
die "Filename contains invalid characters";
}

my $upload_filehandle = $query->upload("photo");

open ( UPLOADFILE, ">$upload_dir/$filename" ) or die "$!";
binmode UPLOADFILE;

while ( <$upload_filehandle> )
{
print UPLOADFILE;
}

close UPLOADFILE;

#my $f=`pwd`."$upload_dir/$filename";
#`ls -l "$upload_dir/$filename">/tmp/t.log`;
`/home/eexp/bin/flow.pl "$upload_dir/$filename"`;

binmode STDOUT, ':utf8';

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
<p><img src=".dot.svg" width="80%" /></p>
</body>
</html>
END_HTML

