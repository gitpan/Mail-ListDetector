package Mail::ListDetector::Detector::Ecartis;

use strict;
use base qw(Mail::ListDetector::Detector::Base);
use Mail::ListDetector::List;
use Email::Valid;

sub DEBUG { 0 }

sub match {
  my $self = shift;
  my $message = shift;
  print "Got message $message\n" if DEBUG;
  carp ("Mail::ListDetector::Detector::Ecartis - no message supplied") unless defined($message);
  my $head = $message->head();
  my @senders = $head->get('Sender');
  my $list;
  foreach my $sender (@senders) {
    chomp $sender;

    ($list) = ($sender =~ /^owner-(\S+)$/);
    if (!(defined $list)) {
      print "Sender didn't match owner-, trying -owner\n" if DEBUG;
      if ($sender =~  /^(\S+?)-owner/) {
        print "Sender matched -owner, removing\n" if DEBUG;
        $list = $sender;
        $list =~ s/-owner@/@/;
      } else {
        print "Sender didn't match second owner form\n" if DEBUG;
        if ($sender =~ /^(\S+?)-bounce/) {
          print "Sender matched -bounce, removing\n" if DEBUG;
          $list = $sender;
          $list =~ s/-bounce@/@/;
        } else {
          print "Sender didn't match bounce form\n" if DEBUG;
        }
      }
    }
    last if defined $list;
  }

  return unless defined $list;
  chomp $list;
  print "Got list [$list]\n" if DEBUG;
  return unless Email::Valid->address($list);
  print "List is valid email\n" if DEBUG;

  # get Ecartis version
  my $lv = $head->get('X-Ecartis-Version');
  return undef unless defined $lv;
  chomp $lv;
  my $listname = $head->get('X-List');
  return undef unless defined $listname;
  chomp $listname;
  my $l = new Mail::ListDetector::List;
  $l->listsoftware($lv);
  $l->posting_address($list);
  $l->listname($listname);
  return $l;
}

1;

__END__

=pod

=head1 NAME

Mail::ListDetector::Detector::Ecartis - Ecartis message detector

=head1 SYNOPSIS

  use Mail::ListDetector::Detector::Ecartis;

=head1 DESCRIPTION

An implementation of a mailing list detector, for Ecartis.

Ecartis can be configured for rfc2369 compliance, however often this is not
done.  If an Ecartis list is configured to be rfc2369 compliant then it will
be recognized by that detector instead.

=head1 METHODS

=head2 new()

Inherited from L<Mail::ListDetector::Detector::Base>.

=head2 match()

Accepts a L<Mail::Internet> object and returns either a
L<Mail::ListDetector::List> object if it is a post to a Ecartis
mailing list, or C<undef>.

=head1 BUGS

None known.

=head1 AUTHOR

Michael Stevens - michael@etla.org.

=cut
