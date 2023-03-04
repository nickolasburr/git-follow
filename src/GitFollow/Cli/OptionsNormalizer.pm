###
### git-follow - Follow lifetime changes of a pathspec in Git.
###
### Copyright (C) 2023 Nickolas Burr <nickolasburr@gmail.com>
###
package GitFollow::Cli::OptionsNormalizer;

use 5.008;
use strict;
use warnings;
use Exporter qw(import);
use GitFollow::Log qw(parse_opts);
use GitFollow::Stdlib::NumberUtils qw(is_numeric);

our @EXPORT_OK = qw(
	format
	normalize
);

# git-follow long options and their imcompatible
# git-<cmd> long/short option counterparts.
my %conflicts = (
	"no-merges" => {
		"log" => ["m"],
	},
	"no-patch" => {
		"log" => ["patch"],
	},
	"no-renames" => {
		"log" => ["follow"],
	},
	"reverse" => {
		"log" => [
			"graph",
			"follow",
		],
	},
);

# Format handlers by command and option(s).
my %handlers = (
	"log" => \&parse_opts,
);

sub format;
sub normalize;

# Format alias, passthrough options,
# and option arguments for commands.
sub format {
	my $cmd = shift;
	die sprintf("No command handler for '%s'\n", $cmd) if not exists $handlers{$cmd};
	return $handlers{$cmd}->(@_);
}

# Remove incompatible/conflicting options.
sub normalize {
	my ($opts, $opt, $cmd) = @_;
	$cmd = 'log' if not defined $cmd;

	if (exists $conflicts{$opt}) {
		my $copts = $conflicts{$opt}->{$cmd};

		foreach my $copt (values @$copts) {
			delete $opts->{$copt} if exists $opts->{$copt};
		}
	}
}

1;
