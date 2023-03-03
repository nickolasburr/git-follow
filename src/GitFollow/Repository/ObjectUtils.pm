###
### git-follow - Follow lifetime changes of a pathspec in Git.
###
### Copyright (C) 2023 Nickolas Burr <nickolasburr@gmail.com>
###
package GitFollow::Repository::ObjectUtils;

use 5.008;
use strict;
use warnings;
use Exporter qw(import);
use GitFollow::Environment qw($GIT_PATH);

our @EXPORT = qw(
	is_object
	is_repo
);

sub is_object;
sub is_repo;

# Determine if pathspec is a valid file object.
sub is_object {
	my ($refspec, $pathspec) = @_;

	# Validate pathspec via git-cat-file(1).
	system("$GIT_PATH cat-file -e $refspec:$pathspec &>/dev/null");
	!($? >> 8);
}

# Determine if we're inside a Git repository.
sub is_repo {
	system("$GIT_PATH rev-parse --is-inside-work-tree &>/dev/null");
	!($? >> 8);
}

1;
