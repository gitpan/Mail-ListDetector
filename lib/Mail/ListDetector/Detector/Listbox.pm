package Mail::ListDetector::Detector::Listbox;

use strict;
use vars qw($VERSION);
$VERSION = '0.01';

use base qw(Mail::ListDetector::Detector::Base);
use Mail::ListDetector::List;

sub DEBUG { 0 }

sub match {
  my $self = shift;
  my $message = shift;
  print "Got message $message\n" if DEBUG;
  carp ("Mail::ListDetector::Detector::Listbox - no message supplied") unless defined($message);
  my $head = $message->head();

  my $list_id = $head->get('List-Id');
  if (defined($list_id) && ($list_id =~ m/<(.*\@v2.listbox.com)>/)) {
    my $posting_address = $1;
    
	my $list = new Mail::ListDetector::List;
    $list->listname($posting_address);
    $list->listsoftware('Listbox v2');
    $list->posting_address($posting_address);

    return $list;
  } else {
	return undef;
  }
}

1;

__END__

=pod

=head1 NAME

Mail::ListDetector::Detector::Listbox - Listbox message detector

=head1 SYNOPSIS

  use Mail::ListDetector::Detector::Listbox;

=head1 DESCRIPTION

An implementation of a mailing list detector, for Listbox mailing lists,
Listbox is a commercial list hosting service, see http://www.listbox.com/
for details about Listbox.

When used this module installs itself to Mail::ListDetector. Listbox
mailing list messages look like RFC2919 messages to the current RFC2919
detector (although they are not compliant) but this module provides more
information and does not test for their full compliance (like a future
RFC2919 module might). For this reason this module must be installed
before the RFC2919 module.

=head1 METHODS

=head2 new()

Inherited from Mail::ListDetector::Detector::Base.

=head2 match()

Accepts a Mail::Internet object and returns either a
Mail::ListDetector::List object if it is a post to a Listbox
mailing list, or C<undef>.

=head1 BUGS

No known bugs.

=head1 AUTHOR

Matthew Walker - matthew@walker.wattle.id.au,
Michael Stevens - michael@etla.org,
Peter Oliver - p.d.oliver@mavit.freeserve.co.uk.
Tatsuhiko Miyagawa E<lt>miyagawa@bulknews.netE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

