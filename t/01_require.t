#!/usr/bin/perl -w

use strict;

$| = 1;

print "1..1\n";

eval "
  use Mail::ListDetector;
  use Mail::ListDetector::List;
  use Mail::ListDetector::Detector::Base;
  use Mail::ListDetector::Detector::Mailman;
";

if ($@) {
  print "not ";
}

print "ok 1\n";
