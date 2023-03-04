###
### git-follow - Follow lifetime changes of a pathspec in Git.
###
### Copyright (C) 2017 Nickolas Burr <nickolasburr@gmail.com>
###
package GitFollow::Log;

use 5.008;
use strict;
use warnings;
use Exporter qw(import);
use GitFollow::Environment qw($GIT_PATH);

our @EXPORT_OK = qw(
	parse_opts
	print_total
	set_refspec
	$DEFAULT_LOG_FMT
	$INVALID_PATH_ERR
	$INVALID_PATH_WITHIN_RANGE_ERR
	$INVALID_REPO_ERR
	$INVALID_REPO_HINT
);

our %parts = (
	"hash"  => "%C(bold cyan)%h%Creset",
	"tree"  => "%C(bold magenta)%t%Creset",
	"entry" => "%s",
	"name"  => "%C(bold blue)%an%Creset",
	"email" => "%C(bold yellow)%ae%Creset",
	"time"  => "%C(bold green)%cr%Creset",
);

# Default git-log(1) format.
our $DEFAULT_LOG_FMT = "$parts{'hash'} ($parts{'tree'}) - $parts{'entry'} - $parts{'name'} <$parts{'email'}> [$parts{'time'}]";

###
### Environment variables.
###

our $GIT_FOLLOW_DIFF_MODE  = undef;
our $GIT_FOLLOW_LOG_FORMAT = undef;
our $GIT_FOLLOW_NO_PAGER   = undef;

###
### User errors, notices, hints, etc.
###

our $INVALID_REFNAME   = "%s is not a valid %s.\n";
our $INVALID_NUM_ARG   = "%s is not a valid number.\n";
our $INVALID_REF_COMBO = "Only one --branch or one --tag option can be specified at a time.\n";
our $INVALID_REPO_ERR  = "%s is not a Git repository.\n";
our $INVALID_REPO_HINT = "FYI: If you don't want to change directories, you can run 'git -C /path/to/repository follow ...'\n";
our $INVALID_PATH_ERR  = "%s is not a valid pathspec.\n";
our $INVALID_PATH_WITHIN_RANGE_ERR = "%s is not a valid pathspec within range %s.\n";

###
### git-follow(1) subroutines.
###

sub parse_opts;
sub get_rev_range;
sub print_total;
sub set_refspec;

# Get revision range via start and end boundaries.
sub get_rev_range {
	my $range = shift;
	my ($start, $end) = split ',', $range;

	# If no end revision was given, default to HEAD.
	$end = "HEAD" unless defined $end;
	return "$start..$end";
}

# Format alias, passthrough options
# and option arguments for git-log(1).
sub parse_opts {
	my ($pathspec, $opt, @args) = @_;

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

		die sprintf($INVALID_NUM_ARG, $num) unless is_numeric($num);
		return "--max-count=$num";
	} elsif ($opt eq "lines") {
		my $lines = shift @args;
		my ($start, $end) = split ',', $lines;

		if (defined $end) {
			return "-L$start,$end:$pathspec";
		} else {
			return "-L$start:$pathspec"
		}
	} elsif ($opt eq "pickaxe") {
		my $subject = shift @args;
		return "-S$subject";
	} else {
		return "--$opt";
	}
}

# Update package-level `$refspec` with ref given via --branch or --tag.
sub set_refspec {
	my ($opt, $ref, $refspec) = @_;

	# If `$refspec` is already defined, notify the user and emit an error,
	# as options `--branch`, `--range`, and `--tag` are mutually exclusive.
	die "$INVALID_REF_COMBO" unless length $refspec;

	if ($opt eq "range") {
		$$refspec = get_rev_range($ref);
	} else {
		my $refs = `$GIT_PATH $opt --list`;
		my $remotes = `$GIT_PATH branch -r` if $opt eq "branch";
		$refs = $refs . $remotes if defined $remotes;

		# Filter asterisk, escape codes from `git {branch,tag} --list`.
		$refs =~ s/\*//gi;
		$refs =~ s/\033\[\d*(;\d*)*m//g;

		# Split refspecs into an array, trim whitespace from each element.
		my @refspecs = split "\n", $refs;
		@refspecs = grep { $_ =~ s/^\s+//; $_; } @refspecs;

		# If `$ref` is indeed a valid refspec, update `$refspec`.
		if (grep /^$ref$/, @refspecs) {
			$$refspec = $ref;
		} else {
			# Otherwise, emit an error specific to
			# the option given and exit the script.
			die sprintf($INVALID_REFNAME, $ref, $opt);
		}
	}
}

# Print total number of commits for pathspec.
sub print_total {
	my $pathspec = shift;

	# Whether to use rename detection or stop at renames.
	my $fopt = (grep { $_ eq "--no-renames" || $_ eq "-O" } @ARGV)
	         ? "--no-renames" : "--follow";

	# Use pathspec, if defined. Otherwise,
	# get the last element in @ARGV array.
	my $path = (defined $pathspec)
	         ? $pathspec : $ARGV[$#ARGV];

	# Array of abbreviated commit hashes.
	my @hashes = `$GIT_PATH log $fopt --format=\"%h\" -- $path`;

	print scalar @hashes;
	print "\n";

	exit 0;
}

1;
