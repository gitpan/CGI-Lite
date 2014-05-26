#
#===============================================================================
#
#         FILE:  forms.t
#
#  DESCRIPTION:  Test form-handling
#
#        FILES:  post_text.txt
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Pete Houston (cpan@openstrike.co.uk)
#      COMPANY:  Openstrike
#      VERSION:  $Id: forms.t,v 1.1 2014/05/26 15:40:05 pete Exp $
#      CREATED:  14/05/14 12:27:26
#     REVISION:  $Revision: 1.1 $
#===============================================================================

use strict;
use warnings;

use Test::More tests => 22;                      # last test to print

use lib './lib';

BEGIN { use_ok ('CGI::Lite') }

# Set up a CGI environment
$ENV{REQUEST_METHOD}  = 'GET';
$ENV{QUERY_STRING}    = 'game=chess&game=checkers&weather=dull';
$ENV{PATH_INFO}       = '/somewhere/else';
$ENV{PATH_TRANSLATED} = '/usr/local/somewhere/else';
$ENV{SCRIPT_NAME}     = '/cgi-bin/foo.cgi';
$ENV{SERVER_PROTOCOL} = 'HTTP/1.0';
$ENV{SERVER_PORT}     = 8080;
$ENV{SERVER_NAME}     = 'the.good.ship.lollypop.com';

CGI::Lite->parse_form_data;

my $cgi   = CGI::Lite->new;
my $form  = $cgi->parse_form_data;

is ($cgi->is_error, 0, 'Parsing data with GET');
is ($form->{weather}, 'dull', 'Parsing scalar param with GET');
is (ref $form->{game}, 'ARRAY', 'Parsing array param with GET');
is ($form->{game}->[1], 'checkers', 'Extracting array param value with GET');

$ENV{QUERY_STRING}    =~ s/\&/;/g;
$form = $cgi->parse_new_form_data;

is ($cgi->is_error, 0, 'Parsing semicolon data with GET');
is ($form->{weather}, 'dull', 'Parsing semicolon scalar param with GET');
is (ref $form->{game}, 'ARRAY', 'Parsing semicolon array param with GET');
is ($form->{game}->[1], 'checkers', 'Extracting semicolon array param value with GET');

$ENV{QUERY_STRING}    = '&=&&foo=bar';
$form = $cgi->parse_new_form_data;

is ($cgi->is_error, 0, 'GET with missing kv pair');
is ($form->{foo}, 'bar', 'Value after GET with missing kv pair');

# Now with POSTed application/x-www-form-urlencoded
$ENV{REQUEST_METHOD}  = 'POST';
$ENV{QUERY_STRING}    = '';
my $datafile = 't/post_text.txt';

$ENV{CONTENT_LENGTH}  = (stat ($datafile))[7];
# Now what? Print to STDIN?
#

($cgi, $form) = post_data ($datafile);

is ($cgi->is_error, 0, 'Parsing data with POST');
is ($form->{bar}, 'quux', 'Parsing scalar param with POST');
is (ref $form->{foo}, 'ARRAY', 'Parsing array param with POST');
is ($form->{foo}->[1], 'baz', 'Extracting array param value with POST');

$ENV{CONTENT_TYPE} = 'baz';
($cgi, $form) = post_data ($datafile);
is ($cgi->is_error, 1, 'Invalid content type with POST');
is ($cgi->get_error_message, 'Invalid content type!', 'Invalid content type message with POST');

$ENV{CONTENT_TYPE} = 'application/x-www-form-urlencoded';
($cgi, $form) = post_data ($datafile);
is ($cgi->is_error, 0, 'Content type x-www-form-urlencoded with POST');

$ENV{CONTENT_TYPE} = 'application/x-www-form-urlencoded; charset=UTF-8';
($cgi, $form) = post_data ($datafile);
is ($cgi->is_error, 0, 'Content type x-www-form-urlencoded and charset with POST');
is ($form->{bar}, 'quux', 'Scalar param with POST as x-www-form-urlencoded');
is (ref $form->{foo}, 'ARRAY', 'Parsing array param with POST as x-www-form-urlencoded');
is ($form->{foo}->[1], 'baz', 'Extracting array param value with POST as x-www-form-urlencoded');

sub post_data {
	my $datafile = shift;
    local *STDIN;
	open STDIN, '<', $datafile
		or die "Cannot open test file $datafile: $!";
	binmode STDIN;
	my $cgi = CGI::Lite->new;
	my $form = $cgi->parse_form_data;
	close STDIN;
	return ($cgi, $form);
}
