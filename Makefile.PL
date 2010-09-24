use 5.010000;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
  NAME          => 'URI::UTF8::Punycode',
  VERSION_FROM  => 'lib/URI/UTF8/Punycode.pm',
  ABSTRACT_FROM => 'lib/URI/UTF8/Punycode.pm',
  AUTHOR        => 'Twinkle Computing <twinkle@cpan.org>',
  LICENSE       => 'gpl',
  VERSION_FROM  => 'lib/URI/UTF8/Punycode.pm',
  INC           => '-Iidn'
);
