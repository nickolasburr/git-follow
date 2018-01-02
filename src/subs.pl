###
### git-follow(1) subroutines.
###

use 5.008;
use strict;
use warnings;
require "common.pl"

###
### User errors, notices.
###

our $INVALID_BRANCHREF;
our $INVALID_TAGREF;
our $INVALID_REF_COMBO;

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

our %git_log_options = (
	"m"      => "-m",
	"follow" => "--follow",
	"format" => "--format=$GIT_FOLLOW_LOG_FORMAT",
	"graph"  => "--graph",
	"patch"  => "--patch-with-stat",
);

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
