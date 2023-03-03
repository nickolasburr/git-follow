###
### git-follow - Follow lifetime changes of a pathspec in Git.
###
### Copyright (C) 2023 Nickolas Burr <nickolasburr@gmail.com>
###
package GitFollow::Environment;

use 5.008;
use strict;
use warnings;
use Exporter qw(import);

our @EXPORT = qw(
	$GIT_PATH
);

our $GIT_PATH = exists $ENV{'GIT_PATH'}
    ? $ENV{'GIT_PATH'} : '/usr/bin/git';

1;
