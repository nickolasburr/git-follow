###
### git-follow - Follow lifetime changes of a pathspec in Git.
###
### Copyright (C) 2017 Nickolas Burr <nickolasburr@gmail.com>
###

package GitFollow::Core;
use 5.008;
use strict;
use warnings;
use Exporter qw(import);

our @EXPORT_OK = qw(
	get_format_ropt
	is_pathspec
	set_args
	set_refspec
	set_unary_opt
);

our %colors = (
	"h"  => "bold cyan",
	"t"  => "bold magenta",
	"an" => "bold blue",
	"ae" => "bold yellow",
	"cr" => "bold green",
);

our $reset = "%Creset";

# Default git-log format.
our $LOG_FMT = "%C($colors{'h'})%h$reset (%C($colors{'t'})%t$reset) - %s - %C($colors{'an'})%an$reset <%C($colors{'ae'})%ae$reset> [%C($colors{'cr'})%cr$reset]";

# Current release version.
our $GIT_FOLLOW_VERSION = "1.1.4";

###
### Environment variables.
###

our $GIT_FOLLOW_DIFF_MODE  = undef;
our $GIT_FOLLOW_LOG_FORMAT = undef;
our $GIT_FOLLOW_NO_PAGER   = undef;

# Diff mode for patch views (defaults to inline).
if (&has_config('diff', 'mode')) {
	$GIT_FOLLOW_DIFF_MODE = &get_config('diff', 'mode');
} elsif (defined $ENV{'GIT_FOLLOW_DIFF_MODE'}) {
	$GIT_FOLLOW_DIFF_MODE = $ENV{'GIT_FOLLOW_DIFF_MODE'}
}

# Log format. Defaults to the following format:
# --------------------------------------------------------------
# commit (tree) - subject - author name <author email> [timestamp]
if (&has_config('log', 'format')) {
	$GIT_FOLLOW_LOG_FORMAT = &get_config('log', 'format');
} elsif (defined $ENV{'GIT_FOLLOW_LOG_FORMAT'}) {
	$GIT_FOLLOW_LOG_FORMAT = $ENV{'GIT_FOLLOW_LOG_FORMAT'};
} else {
	$GIT_FOLLOW_LOG_FORMAT = $LOG_FMT;
}

# Disable pager. Defaults to 0 (use pager).
if (&has_config('pager', 'disabled')) {
	$GIT_FOLLOW_NO_PAGER = &get_config('pager', 'disabled');
} elsif (defined $ENV{'GIT_FOLLOW_NO_PAGER'}) {
	$GIT_FOLLOW_NO_PAGER = $ENV{'GIT_FOLLOW_NO_PAGER'};
}

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

our @git_log_option_values;
our %options;
our $pathspec;
our $refspec;

# Options and their conflicting counterparts.
our %copts = (
	"no-merges"  => [
		"m",
	],
		"no-patch"   => [
		"patch",
	],
		"no-renames" => [
		"follow",
	],
	"reverse"    => [
		"graph",
		"follow",
	],
);

# Default argument values for options that accept arguments.
our %dargs = (
	"last"  => 1,
	"lines" => 1,
);

# Diff modes and their git-log option counterparts.
our %diffopts = (
	"inline"   => "none",
	"sxs"      => "plain",
	"colorsxs" => "color",
);

# Base components of `git log` shell command, represented
# as an array to make it easier to pass to `system` builtin.
our @git_log = (
	"git",
	"log",
);

our %git_log_options = (
	"m"      => "-m",
	"follow" => "--follow",
	"format" => "--format=$GIT_FOLLOW_LOG_FORMAT",
	"graph"  => "--graph",
	"patch"  => "--patch-with-stat",
);

###
### git-follow(1) subroutines.
###

sub get_config;
sub has_config;
sub is_int;
sub is_pathspec;
sub get_revr;
sub get_format_ropt;
sub rm_copts;
sub set_args;
sub set_unary_opt;
sub set_refspec;
sub show_total;
sub show_version;

# Get git-config value.
sub get_config {
	my ($key, $qual) = @_;
	my $config = undef;

	system("git config follow.$key.$qual >/dev/null");

	$config = (!$?)
	        ? `git config follow.$key.$qual`
	        : `git config follow.$key$qual`;

	# Strip trailing newline from config value.
	chomp $config;

	return $config;
}

# Check if git-config key exists.
sub has_config {
	my ($key, $qual) = @_;

	system("git config follow.$key.$qual >/dev/null");

	if (!$?) {
		return 1;
	}

	system("git config follow.$key$qual >/dev/null");

	!$?;
}

# Determine if value is an integer.
sub is_int {
	my $num = shift;

	if (defined $num) {
		return $num =~ /^\d+$/ ? 1 : 0;
	} else {
		return 0;
	}
}

# Determine if pathspec is a valid file object.
sub is_pathspec {
	my ($refname, $target) = @_;

	# Validate pathspec via git-cat-file.
	system("git cat-file -e $refname:$target &>/dev/null");

	return !($? >> 8);
}

# Get rev range for the given pathspec.
sub get_revr {
	my $revr_start = shift;
	my $revr_end   = shift;

	# If no end rev was given, default to HEAD.
	$revr_end = "HEAD" if not defined $revr_end;

	# If only an integer was given, interpolate
	# as a rev range for the current branch.
	# --------------------------------------------
	# @todo: Allow refname before '@{n}', either as argument
	# (e.g. --branch master --range 3 5), or passed directly
	# to --range option (e.g. --range master 3 5).
	$revr_start = "\@{$revr_start}" if &is_int($revr_start);
	$revr_end   = "\@{$revr_end}" if &is_int($revr_end);

	return "$revr_start..$revr_end";
}

# Format the `git log` option with argument(s) given.
sub get_format_ropt {
	my ($opt, @args) = @_;

	if ($opt eq "first") {
		return "--diff-filter=A";
	} elsif ($opt eq "func") {
		my $funcname = shift @args;

		return "-L:$funcname:$pathspec";
	} elsif ($opt eq "last") {
		my $num = shift @args;

		if (!$num) {
			$num = 1;
		}

		return "--max-count=$num";
	} elsif ($opt eq "lines") {
		my @nums  = shift @args;
		my $lines = shift @nums;
		my $start = @$lines[0];
		my $end   = @$lines[1];

		# If no end range was given, only specify start and pathspec.
		if (!$end) {
			return "-L $start:$pathspec"
		} else {
			return "-L $start,$end:$pathspec";
		}
	} elsif ($opt eq "pickaxe") {
		my $subject = shift @args;

		return "-S$subject";
	} elsif ($opt eq "range") {
		my $revs       = shift @args;
		my $revr_start = @$revs[0];
		my $revr_end   = @$revs[1];

		return &get_revr($revr_start, $revr_end);
	} else {
		return "--$opt";
	}
}

# Remove conflicting `git log` options so they're
# not passed to `system`, causing conflict errors.
sub rm_copts {
	my ($opt) = @_;
	my $cnopts = $copts{$opt};

	foreach (values @$cnopts) {
		my $cnopt = shift @$cnopts;
		delete $git_log_options{$cnopt} if exists $git_log_options{$cnopt};
	}
}

# Set argument for `$opt`, whether given to the option or default.
sub set_args {
	my ($opt, $arg) = @_;

	# Update %options hash with either the given option
	# argument or with the default option argument.
	$options{$opt} = !$arg ? $dargs{$opt} : $arg;
}

# Add unary option to `%git_log_options`.
sub set_unary_opt {
	my $nopt = shift;
	# Get formatted `git log` option.
	my $ropt = &get_format_ropt($nopt);

	# Remove conflicting options, add aux option to `%git_log_options`.
	&rm_copts($nopt);
	$git_log_options{$nopt} = $ropt;
}

# Update package-level `$refspec` with ref given via --branch or --tag.
sub set_refspec {
	# If `$refspec` is already defined, notify the user and emit an error,
	# as you can't give both `--branch` and `--tag` options simultaneously.
	if (defined $refspec) {
		die "$INVALID_REF_COMBO";
	}

	# Option name (branch, tag), and refspec (e.g. 'master', 'v1.0.5').
	my ($opt, $ref) = @_;

	my $refs = `git $opt --list`;
	my $remotes = `git branch -r` if $opt eq "branch";
	$refs = $refs . $remotes if defined $remotes;

	# Filter asterisk, escape codes from `git {branch,tag} --list`.
	$refs =~ s/\*//gi;
	$refs =~ s/\033\[\d*(;\d*)*m//g;

	# Split refspecs into an array, trim whitespace from each element.
	my @refspecs = split "\n", $refs;
	@refspecs = grep { $_ =~ s/^\s+//; $_; } @refspecs;

	# If `$ref` is indeed a valid refspec, update `$refspec`.
	if (grep /^$ref$/, @refspecs) {
		$refspec = $ref;
	} else {
		# Otherwise, emit an error specific to
		# the option given and exit the script.
		if ($opt eq "branch") {
			die "$INVALID_BRANCHREF";
		} elsif ($opt eq "tag") {
			die "$INVALID_TAGREF";
		}
	}
}

# Show total number of commits for pathspec.
sub show_total {
	# Whether to use rename detection or stop at renames.
	my $fopt = (grep { $_ eq "--no-renames" || $_ eq "-O" } @ARGV)
	         ? "--no-renames"
	         : "--follow";

	# Use pathspec, if defined. Otherwise,
	# get the last element in @ARGV array.
	my $path = (defined $pathspec)
	         ? $pathspec
	         : $ARGV[$#ARGV];

	# Array of abbreviated commit hashes.
	my @hashes = `git log $fopt --format=\"%h\" -- $path`;

	print scalar @hashes;
	print "\n";

	exit 0;
}

# Show current release version.
sub show_version {
	print "$GIT_FOLLOW_VERSION\n";

	exit 0;
}

1;
