###
### git-follow - Follow lifetime changes of a pathspec in Git.
###
### Copyright (C) 2017 Nickolas Burr <nickolasburr@gmail.com>
###

package GitFollow::Blame;
use 5.008;
use strict;
use warnings;
use Exporter qw(import);

sub get_diff;
sub get_hash;
