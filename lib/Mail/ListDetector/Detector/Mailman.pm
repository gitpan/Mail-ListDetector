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
  my $list;
  $list = new Mail::ListDetector::List;
  $list->listsoftware("GNU Mailman version $version");
  my $list_id = $head->get('List-Id');
  my $listname;
  my $list_full_name;
  if ($list_id =~ /^.*?\ \<(\S+?)\>$/) {
    $list_full_name = $listname = $1;
    ($listname) = ($listname =~ /^([^.]*?)\./);
    $list->listname($listname);
  }
  my $posting_address;
  my $list_post = $head->get('List-Post');
  if (defined $list_post) {
    if ($list_post =~ /^\<mailto\:([^\>]*)\>$/) {
      $posting_address = $1;
      $list->posting_address($posting_address);
    }
  } else {
    $posting_address = $list_full_name;
    $posting_address =~ s/\./\@/;
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

