package Mail::ListDetector::Detector::Mailman;

use strict;
use base qw(Mail::ListDetector::Detector::Base);
use Mail::ListDetector::List;

sub DEBUG { 0 }

sub match {
  my $self = shift;
  my $message = shift;
  print "Got message $message\n" if DEBUG;
  carp ("Mail::ListDetector::Detector::Mailman - no message supplied") unless defined($message);
  my $head = $message->head();
  my $version = $head->get('X-Mailman-Version');
  chomp $version if defined $version;
  if ((!defined $version) or $version =~ /^\s*$/) {
    print "Returning undef - couldn't find mailman version - $version\n" if DEBUG;
    return undef;
  }
  print "Mailman version $version\n" if DEBUG
  my $list;
  $list = new Mail::ListDetector::List;
  $list->listsoftware("GNU Mailman version $version");
  my $list_id = $head->get('List-Id');
  print "List-Id is $list_id\n" if DEBUG;
  return undef unless defined $list_id;
  chomp $list_id;
  my $listname;
  my $list_full_name;
  if ($list_id =~ /^.*?\ ?<(\S+?)\>$/) {
    print "Listid matches pattern\n" if DEBUG;
    $list_full_name = $listname = $1;
    ($listname) = ($listname =~ /^([^.]*?)\./);
    print "Got listname $listname\n" if DEBUG;
    $list->listname($listname);
  } else {
    print "List id doesn't match\n" if DEBUG;
    return undef;
  }
  my $posting_address;
  my $list_post = $head->get('List-Post');
  if (defined $list_post) {
    print "Got list post $list_post\n" if DEBUG;
    if ($list_post =~ /^\<mailto\:([^\>]*)\>$/) {
      $posting_address = $1;
      print "Got posting address $posting_address\n" if DEBUG;
      $list->posting_address($posting_address);
    }
  } else {
    $posting_address = $list_full_name;
    $posting_address =~ s/\./\@/;
    print "Got posting address $posting_address\n" if DEBUG;
    $list->posting_address($posting_address);
  }

  print "Returning object $list\n" if DEBUG;
  return $list;
}

1;

__END__

=pod

=head1 NAME

Mail::ListDetector::Detector::Mailman - Mailman message detector

=head1 SYNOPSIS

  use Mail::ListDetector::Detector::Mailman;

=head1 DESCRIPTION

An implementation of a mailing list detector, for GNU Mailman.

=head1 METHODS

=head2 new()

Inherited from L<Mail::ListDetector::Detector::Base>.

=head2 match()

Accepts a L<Mail::Internet> object and returns either a
L<Mail::ListDetector::List> object if it is a post to a Mailman
mailing list, or C<undef>.

=head1 BUGS

No known bugs.

=head1 AUTHOR

Michael Stevens - michael@etla.org.

=cut

