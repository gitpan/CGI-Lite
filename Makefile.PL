use ExtUtils::MakeMaker;
require 5.002;

$VERSION = "2.02";

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

Now do the following to install CGI::Lite $VERSION:

    % make 
    % make install

End_of_Text
