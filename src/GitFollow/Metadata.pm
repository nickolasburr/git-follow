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

our @EXPORT_OK = qw(
	get_version
	print_version
	print_usage
	$GIT_FOLLOW_VERSION
);

# Current release version.
our $GIT_FOLLOW_VERSION = "1.1.5";
my $USAGE_SYNOPSIS = <<"END_USAGE_SYNOPSIS";

  Usage: git follow [OPTIONS] [--] <pathspec>

  OPTIONS:

    -b, --branch <branchref>            Show commits for pathspec, specific to a branch.
    -f, --first                         Show first commit where Git initiated tracking of pathspec.
    -F, --func <funcname>               Show commits which affected function <funcname> in pathspec.
    -l, --last [<count>]                Show last <count> commits which affected pathspec. Omitting <count> defaults to last commit.
    -L, --lines <start> [<end>]         Show commits which affected lines <start> through <end> in pathspec. Omitting <end> defaults to EOF.
    -M, --no-merges                     Show commits which have a maximum of one parent. See --no-merges of git-log(1).
    -N, --no-patch                      Suppress diff output. See --no-patch of git-log(1).
    -O, --no-renames                    Disable rename detection. See --no-renames of git-log(1).
    -p, --pager                         Force pager when invoking git-log(1). Overrides follow.pager.disable config value.
    -P, --pickaxe <string>              Show commits which change the number of occurrences of <string> in pathspec. See -S of git-log(1).
    -r, --range <startref> [<endref>]   Show commits in range <startref> to <endref> which affected pathspec. Omitting <endref> defaults to HEAD. See gitrevisions(1).
    -R, --reverse                       Show commits in reverse chronological order. See --walk-reflogs of git-log(1).
    -t, --tag <tagref>                  Show commits for pathspec, specific to a tag.
    -T, --total                         Show total number of commits for pathspec.
    -V, --version                       Show current release version.

END_USAGE_SYNOPSIS

sub get_version;
sub print_version;
sub print_usage;

# Get current release version.
sub get_version {
	return $GIT_FOLLOW_VERSION;
}

# Print current release version.
sub print_version {
	print "$GIT_FOLLOW_VERSION\n";
	exit 0;
}

# Print usage information.
sub print_usage {
	my $code = shift;
	$code = 0 if not defined $code;

	print "$USAGE_SYNOPSIS";
	exit $code;
}

1;
