package Mail::ListDetector::Detector::Listar;

use strict;
use base qw(Mail::ListDetector::Detector::Base);
use Mail::ListDetector::List;
use Email::Valid;

sub DEBUG { 0 }

sub match {
  my $self = shift;
  my $message = shift;
  print "Got message $message\n" if DEBUG;
  carp ("Mail::ListDetector::Detector::Listar - no message supplied") unless defined($message);
  my $head = $message->head();
  my @senders = $head->get('Sender');
  my $list;
  foreach my $sender (@senders) {
    chomp $sender;

    ($list) = ($sender =~ /^owner\-(\S+)$/);
    if (!(defined $list)) {
      print "Sender didn't match owner-, trying -owner\n" if DEBUG;
      if ($sender =~  /^(\S+?)\-owner/) {
        print "Sender matched -owner, removing\n" if DEBUG;
        $list = $sender;
        $list =~ s/\-owner@/@/;
      } else {
        print "Sender didn't match second owner form\n" if DEBUG;
      }
    }
    last if defined $list;
  }

  return unless defined $list;
  chomp $list;
  print "Got list [$list]\n" if DEBUG;
  return unless Email::Valid->address($list);
  print "List is valid email\n" if DEBUG;

  # get listar version
  my $lv = $head->get('X-listar-version');
  return undef unless defined $lv;
  chomp $lv;
  my $listname = $head->get('X-list');
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

Mail::ListDetector::Detector::Listar - Listar message detector

=head1 SYNOPSIS

  use Mail::ListDetector::Detector::Listar;

=head1 DESCRIPTION

An implementation of a mailing list detector, for Listar.

This seems to only match older Listar list versions - newer ones
appear to be rfc2369 compliant, and are recognised as that instead.

=head1 METHODS

=head2 new()

Inherited from L<Mail::ListDetector::Detector::Base>.

=head2 match()

Accepts a L<Mail::Internet> object and returns either a
L<Mail::ListDetector::List> object if it is a post to a listar
mailing list, or C<undef>.

=head1 BUGS

None known.

=head1 AUTHOR

Michael Stevens - michael@etla.org.

=cut

