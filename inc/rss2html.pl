#!/usr/bin/perl
# (/usr/share/doc/perl-XML-RSS-1.45/examples/rss2html.pl)
#
# rss2html - converts an RSS file to HTML
# It take one argument, either a file on the local system,
# or an HTTP URL like http://slashdot.org/slashdot.rdf
# by Jonathan Eisenzopf. v1.0 19990901
# See http://www.webreference.com/perl for more information

# INCLUDES
use strict;
use warnings;

use XML::RSS;
use LWP::Simple;
use Date::Parse;

# Declare variables
my $content;
my $file;

# MAIN
# check for command-line argument
die "Usage: rss2html.pl (<RSS file> | <URL>)  COUNT\n" unless @ARGV >0;

# get the command-line argument
my $arg = shift;
my $max = shift;

if (! $max) { $max = 3; }

# create new instance of XML::RSS
my $rss = new XML::RSS;

# argument is a URL
if ($arg=~ /http:/i) {
    $content = get($arg);
    die "Could not retrieve $arg" unless $content;
    # parse the RSS content
    $rss->parse($content);

# argument is a file
} else {
    $file = $arg;
    die "File \"$file\" does't exist.\n" unless -e $file;
    # parse the RSS file
    $rss->parsefile($file);
}

# print the HTML channel
&print_html($rss, $max);

# SUBROUTINES
# --------------------------------------------------------
sub print_html {
    my $rss = shift;
    my $max = shift;
    # .........................
    # .........................
    # print the channel items
    my $c = 0;
    foreach my $item (@{$rss->{'items'}}) {
	$c++;
	next unless defined($item->{'title'}) && defined($item->{'link'});
	#print "<li><a href=\"$item->{'link'}\">$item->{'title'}</a><BR>\n";
	print "$item->{'title'}|$item->{'link'}|";
	my $ts = time() - str2time($item->{'pubDate'});	# eg: 'Mon, 27 Jan 2020 09:30:11 +1100'
	if ($ts <60) {		print $ts . "s"; }
	elsif ($ts<3600) {	print int($ts/60) ."m"; }
	else {			print int($ts/3600) ."h"; }


	printf "\n";
	last if ($c >= $max);
    }

    # .........................
}

# --------------------------------------------------------
sub print_html_orig {
    my $rss = shift;
    print <<HTML;
<table bgcolor="#000000" border="0" width="100%"><tr><td>
<TABLE CELLSPACING="1" CELLPADDING="4" BGCOLOR="#FFFFFF" BORDER=0 width="100%">
  <tr>
  <td valign="middle" align="center" bgcolor="#EEEEEE"><font color="#000000" face="Arial,Helvetica"><B><a href="$rss->{'channel'}->{'link'}">$rss->{'channel'}->{'title'}</a></B></font></td></tr>
<tr><td>
HTML


    # print channel image
    #if  ($rss->{'image'}->{'link'}) {
    if  (0) {
	print <<HTML;
<center>
<p><a href="$rss->{'image'}->{'link'}"><img src="$rss->{'image'}->{'url'}" alt="$rss->{'image'}->{'title'}" border="0"
HTML
        print " width=\"$rss->{'image'}->{'width'}\""
	    if $rss->{'image'}->{'width'};
	print " height=\"$rss->{'image'}->{'height'}\""
	    if $rss->{'image'}->{'height'};
	print "></a></center><p>\n";
    }


    # print the channel items
    foreach my $item (@{$rss->{'items'}}) {
	next unless defined($item->{'title'}) && defined($item->{'link'});
	print "<li><a href=\"$item->{'link'}\">$item->{'title'}</a><BR>\n";
    }

    # if there's a textinput element
    if ($rss->{'textinput'}->{'title'}) {
	print <<HTML;
<form method="get" action="$rss->{'textinput'}->{'link'}">
$rss->{'textinput'}->{'description'}<BR> 
<input type="text" name="$rss->{'textinput'}->{'name'}"><BR>
<input type="submit" value="$rss->{'textinput'}->{'title'}">
</form>
HTML
    }

    # if there's a copyright element
    if ($rss->{'channel'}->{'copyright'}) {
	print <<HTML;
<p><sub>$rss->{'channel'}->{'copyright'}</sub></p>
HTML
    }

    print <<HTML;
</td>
</TR>
</TABLE>
</td></tr></table>
HTML
}

