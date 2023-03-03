#!/usr/bin/env bash

###
### test.sh: Integrity test of git-follow executable.
###

if [[ -n "$CDPATH" ]]; then
	unset CDPATH
fi

builtin cd ..

TARGET="git-follow"
MDLDIR="/usr/local/opt/git-follow/src"
SRCDIR="src"

SED="/usr/bin/sed"
SEDOPTS="-i ''"
SEDEXPR="s@$MDLDIR@$SRCDIR@g"

# Update 'use lib' directive to 'src' for testing purposes.
eval "$SED $SEDOPTS $SEDEXPR $TARGET"

ERROR=0
TESTS=(
	"--last=5 --no-merges --no-renames"
	"-l 5 -M -O"
	"--first --no-patch --branch=origin/master"
	"-f -N -b origin/master"
	"--last --no-merges --no-patch"
	"-l -M -N"
	"--func=in_array --no-renames"
	"-F in_array -O"
	"--pickaxe=git_track_map_aliases --last --no-patch"
	"-P git_track_map_aliases -l -N"
	"--range 954829d,67bfd35 --no-patch"
	"-r 954829d,67bfd35 -N"
	"--branch origin/master --last --no-merges"
	"-b origin/master -l -M"
	"--last=3 --lines=20,35 --no-merges --no-renames"
	"-l 3 -L 20,35 -M -O"
	"--reverse --last=5 --no-merges --no-renames"
	"-R -l 5 -M -O"
)

for OPTIONS in "${TESTS[@]}"; do
	eval "./$TARGET $OPTIONS -- $TARGET" >/dev/null 2>&1

	if [[ $? -eq 0 ]]; then
		printf 'OK ./%s %s -- %s\n' "$TARGET" "$OPTIONS" "$TARGET"
	else
		printf 'ERROR ./%s %s -- %s\n' "$TARGET" "$OPTIONS" "$TARGET"
		ERROR=1
		break
	fi
done

SEDEXPR="s@$SRCDIR@$MDLDIR@g"

# Reset 'use lib' directive to original path.
eval "$SED $SEDOPTS $SEDEXPR $TARGET"
exit $ERROR
