###
### git-follow - Follow lifetime changes of a pathspec in Git.
###
### Copyright (C) 2023 Nickolas Burr <nickolasburr@gmail.com>
###
package GitFollow::Stdlib::NumberUtils;

use 5.008;
use strict;
use warnings;
use Exporter qw(import);

our @EXPORT_OK = qw(is_numeric);

sub is_numeric;

# Determine if value is numeric.
sub is_numeric {
	my $num = shift;
	return (defined $num)
	    ? ($num =~ /^\d+$/ ? 1 : 0) : 0;
}

1;
