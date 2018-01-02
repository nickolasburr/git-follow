###
### git-follow(1) shared state.
###

use 5.008;
use strict;
use warnings;

# Current release version.
our $GIT_FOLLOW_VERSION = "1.1.4";

###
### Environment variables.
###

# Diff mode for patch views (defaults to inline).
our $GIT_FOLLOW_DIFF_MODE  = (defined $ENV{'GIT_FOLLOW_DIFF_MODE'})
                           ? $ENV{'GIT_FOLLOW_DIFF_MODE'}
                           : undef;

# Log format. Defaults to the following format:
# --------------------------------------------------------------
# commit (tree) - subject - author name <author email> [timestamp]
our $GIT_FOLLOW_LOG_FORMAT = (defined $ENV{'GIT_FOLLOW_LOG_FORMAT'})
                           ? $ENV{'GIT_FOLLOW_LOG_FORMAT'}
                           : "%C(bold cyan)%h%Creset (%C(bold magenta)%t%Creset) - %s - %C(bold blue)%an%Creset <%C(bold yellow)%ae%Creset> [%C(bold green)%cr%Creset]";

# Disable pager. Defaults to 0 (use pager).
our $GIT_FOLLOW_NO_PAGER   = (defined $ENV{'GIT_FOLLOW_NO_PAGER'})
                           ? $ENV{'GIT_FOLLOW_NO_PAGER'}
                           : undef;

###
### User errors, notices, hints, etc.
###

our $INVALID_BRANCHREF = "%s is not a valid branch.\n";
our $INVALID_TAGREF    = "%s is not a valid tag.\n";
our $INVALID_REF_COMBO = "Only one --branch or one --tag option can be specified at a time.\n";
our $INVALID_REPO_ERR  = "%s is not a Git repository.\n";
our $INVALID_REPO_HINT = "FYI: If you don't want to change directories, you can run 'git -C /path/to/repository follow ...'\n";
our $INVALID_PATH_ERR  = "%s is not a valid pathspec.\n";
our $USAGE_SYNOPSIS    = <<"END_USAGE_SYNOPSIS";

  Usage: git follow [OPTIONS] [--] pathspec

  Options:

    --branch,     -b <branchref>             Show commits for pathspec, specific to a branch.
    --first,      -f                         Show first commit where Git initiated tracking of pathspec.
    --func,       -F <funcname>              Show commits which affected function <funcname> in pathspec.
    --last,       -l [<count>]               Show last <count> commits which affected pathspec. Omitting <count> defaults to last commit.
    --lines,      -L <start> [<end>]         Show commits which affected lines <start> through <end> in pathspec. Omitting <end> defaults to EOF.
    --no-merges,  -M                         Show commits which have a maximum of one parent. See --no-merges of git-log(1).
    --no-patch,   -N                         Suppress diff output. See --no-patch of git-log(1).
    --no-renames, -O                         Disable rename detection. See --no-renames of git-log(1).
    --pickaxe,    -P <string>                Show commits which change the number of occurrences of <string> in pathspec. See -S of git-log(1).
    --range,      -r <startref> [<endref>]   Show commits in range <startref> to <endref> which affected pathspec. Omitting <endref> defaults to HEAD. See gitrevisions(1).
    --reverse,    -R                         Show commits in reverse chronological order. See --walk-reflogs of git-log(1).
    --tag,        -t <tagref>                Show commits for pathspec, specific to a tag.
    --total,      -T                         Show total number of commits for pathspec.
    --version,    -V                         Show current release version.

END_USAGE_SYNOPSIS

our %copts;
our %dargs;
our %options;
our %git_log_options;
our @git_log_option_values;
our $pathspec;
our $refspec;

1;
