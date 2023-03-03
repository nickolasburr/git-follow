###
### git-follow - Follow lifetime changes of a pathspec in Git.
###
### Copyright (C) 2023 Nickolas Burr <nickolasburr@gmail.com>
###
package GitFollow::Metadata;

use 5.008;
use strict;
use warnings;
use Exporter qw(import);

our @EXPORT = qw(
	get_version
	print_version
	$GIT_FOLLOW_VERSION
);

# Current release version.
our $GIT_FOLLOW_VERSION = "1.1.5";

sub get_version;
sub print_version;

# Get current release version.
sub get_version {
	return $GIT_FOLLOW_VERSION;
}

# Print current release version.
sub print_version {
	print "$GIT_FOLLOW_VERSION\n";
	exit 0;
}

1;
