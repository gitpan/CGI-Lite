use ExtUtils::MakeMaker;
require 5.002;

$VERSION = "2.001-emergencyrelease";

print "\nWelcome to the installation of CGI::Lite $VERSION...\n\n";

WriteMakefile (
                 NAME      =>   "CGI::Lite",
                 VERSION   =>   "$VERSION",
                 'dist'    =>   {
				    COMPRESS => 'gzip -9f', 
				    SUFFIX   => 'gz'
           			}
              );

print <<End_of_Text;

Note from the CPAN administration: The CGI::Lite module seems to be
abandoned by its original author. We cannot contact him anymore. The
2.0 release has been made on 2000-08-20. This 2.001 release is just an
emergency release that fixes the most urgent security need. It is not
endorsed by the original author. It was put together by me after the
advisory http://msgs.securepoint.com/cgi-bin/get/bugtraq0302/94.html
on the bugtraq mailing list. Thanks to Ronald F. Guilmette for
bringing up this issue.

I do not and will not maintain CGI::Lite and would welcome volunteers
to take it over.

2002-02-17
andreas koenig

End_of_Text
