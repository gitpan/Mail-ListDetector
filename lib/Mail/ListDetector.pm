package Mail::ListDetector;

use strict;
use Carp;
use Mail::ListDetector::Detector::Mailman;
use Mail::ListDetector::Detector::Ezmlm;
use Mail::ListDetector::Detector::Smartlist;
use Mail::ListDetector::Detector::Majordomo;
use Mail::ListDetector::Detector::RFC2369;
use Mail::ListDetector::Detector::Listar;
use Mail::ListDetector::Detector::Yahoogroups;

require Exporter;
use AutoLoader qw(AUTOLOAD);
use vars qw(@ISA %EXPORT_TAGS @EXPORT_OK @EXPORT $VERSION);
use vars qw(@DETECTORS);

@ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Mail::ListDetector ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
%EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

@EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

@EXPORT = qw(
	
);

$VERSION = '0.14';

@DETECTORS = qw(Mailman Ezmlm Smartlist RFC2369 Listar Yahoogroups Majordomo);

foreach (@DETECTORS) {
  $_ = "Mail::ListDetector::Detector::" . $_;
}

# package subs

sub new {
  my $proto = shift;
  my $message = shift;
  carp("Mail::ListDetector:: no message supplied\n") unless defined($message);
  my $class = ref($proto) || $proto;

  # get message

  # for all detectors, instantiate and pass until one returns
  # an object
  my $list;
  foreach my $detector_name (@DETECTORS) {
    my $detector;
    $detector = eval "new $detector_name";
    if ($@) {
    	die $@;
    }
    if ($list = $detector->match($message)) {
      return $list;
    }
  }
  
  return undef;
}


1;
__END__

=head1 NAME

Mail::ListDetector - Perl extension for detecting mailing list messages

=head1 SYNOPSIS

  use Mail::ListDetector;

=head1 DESCRIPTION

This module analyzses L<Mail:;Internet> objects. It returns a 
L<Mail::ListDetector::List> object representing the mailing list.

The RFC2369 mailing list detector is also capable of matching some
Mailman and Ezmlm messages. It is deliberately checked last to allow
the more specific Mailman and Ezmlm parsing to happen first, and more
accurately identify the type of mailing list involved.

=head1 METHODS

=head1 new()

This method is the core of the module. Pass it a L<Mail::Internet>
object, it will either return a L<Mail::ListDetector::List> object that
describes the mailing list that the message was posted to, or
C<undef> if it appears not to have been a mailing list post.

=head1 EMAILS USED

This module includes a number of sample emails from various mailing
lists. In all cases, mails are used with permission of the author, and
must not be distributed separately from this archive. If you believe
I may have accidentally used your email or content without permission,
contact me, and if this turns out to be the case I will immediately remove
it from the latest version of the archive.

=head1 BUGS

=over 4

=item *

A lot of the code applies fairly simple regular expressions to email
address to extract information. This may fall over for really weird
email addresses, but I'm hoping no-one will use those for names of
mailing lists.

=item *

The majordomo and smartlist recognisers don't have much to go on,
and therefore are probably not as reliable as the other detectors.
This is liable to be hard to fix.

=item *

Forwarding messages (for example using procmail) can sometimes break
the C<Sender: > header information needed to recognise some list
types.

=back

=head1 AUTHOR

Michael Stevens - michael@etla.org.

=head1 SEE ALSO

perl(1).

=cut
