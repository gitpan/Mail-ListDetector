use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'          => 'Mail::ListDetector',
    'VERSION_FROM'  => 'lib/Mail/ListDetector.pm', # finds $VERSION
    'PREREQ_PM'     => {
                        'Carp'           => 0,
                        'Mail::Internet' => 1.33,
                        'Email::Valid'   => 0.12,
                        'URI'            => 1.10,
                        'Test::More'     => 0.08,
                        'Mail::ListDetector::Detector::Fml' => 0.03,
                       }, 
    'dist' => { 'COMPRESS' => 'gzip -9f',
                'SUFFIX'   => 'gz',
    },
    'AUTHOR'        => 'Michael Stevens <michael@etla.org>',
    'ABSTRACT'      => 'Mailing list message detector',
);
