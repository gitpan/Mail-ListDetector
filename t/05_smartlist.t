#!/usr/bin/perl -w

use strict;
use Test::More tests => 4;
use Mail::Internet;
use Mail::ListDetector;

my $mail;

$mail = new Mail::Internet(\*DATA);

my $list = new Mail::ListDetector($mail);

ok(defined($list), 'List is defined');
is($list->listname, 'thoth-devel', 'list is thoth-devel');
is($list->listsoftware, 'smartlist', 'software is smartlist');
is($list->posting_address, 'thoth-devel@firedrake.org', 'posting address');

# Email used with permission from roger, assuming tests only
# available to those downloading the archive.

__DATA__
From roger@firedrake.org Thu Jan  4 17:37:27 2001
Envelope-to: mstevens@firedrake.org
Received: from cvoo.cvoo.nl [195.11.247.38] 
	by dayspring.firedrake.org with esmtp (Exim 3.12 #1 (Debian))
	id 14EEKN-0007mN-00; Thu, 04 Jan 2001 17:37:27 +0000
Received: from [195.82.105.251] (helo=dayspring.firedrake.org ident=mail)
	from mail by cvoo.cvoo.nl with esmtp id 14EEKN-000Pqj-00
	for mstevens@globnix.org; Thu, 04 Jan 2001 17:37:27 +0000
Received: from list by dayspring.firedrake.org with local (Exim 3.12 #1 (Debian))
	id 14EEKJ-0007m8-00; Thu, 04 Jan 2001 17:37:23 +0000
Date: Thu, 4 Jan 2001 17:37:23 +0000
From: Roger Burton West <roger@firedrake.org>
To: thoth-devel@firedrake.org
Subject: Another new thoth version
Message-ID: <20010104173723.A29849@firedrake.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
X-Phase-Of-Moon: The Moon is Waxing Gibbous (68% of Full)
X-Discordian-Date: Prickle-Prickle, Chaos 4 3167
Resent-Message-ID: <unFZLD.A.BTH.TTLV6@dayspring>
Resent-From: thoth-devel@firedrake.org
X-Mailing-List: <thoth-devel@firedrake.org> archive/latest/37
X-Loop: thoth-devel@firedrake.org
Reply-To: thoth-devel@firedrake.org
Precedence: list
Resent-Sender: thoth-devel-request@firedrake.org
Resent-Bcc:
Resent-Date: Thu, 04 Jan 2001 17:37:23 +0000
Status: RO

The multi-monitor section of the config file is now permanently GONE.
WinNT integration coming one of these days.

Future directions: ssh-piped thoth cascading, e.g. integrate multiple
monitor boxes into a single display...

C'mon, guys, try it! (Ideally, someone write a user interface for the
damn thing...)

R


