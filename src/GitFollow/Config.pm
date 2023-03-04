###
### git-follow - Follow lifetime changes of a pathspec in Git.
###
### Copyright (C) 2023 Nickolas Burr <nickolasburr@gmail.com>
###
package GitFollow::Config;

use 5.008;
use strict;
use warnings;
use Exporter qw(import);
use GitFollow::Environment qw($GIT_PATH);

our @EXPORT_OK = qw(
	get_config
	has_config
);

sub get_config;
sub has_config;

# Get git-config(1) value.
sub get_config {
	my ($grp, $key) = @_;
	my $config = undef;

	system("$GIT_PATH config follow.$grp.$key >/dev/null");

	$config = (!$?)
	        ? `$GIT_PATH config follow.$grp.$key`
	        : `$GIT_PATH config follow.$grp$key`;

	# Strip trailing newline from config value.
	chomp $config;
	return $config;
}

# Check if git-config(1) key exists.
sub has_config {
	my ($grp, $key) = @_;

	system("$GIT_PATH config follow.$grp.$key >/dev/null");
	return 1 unless $?;

	system("$GIT_PATH config follow.$grp$key >/dev/null");
	!($? >> 8);
}

1;
