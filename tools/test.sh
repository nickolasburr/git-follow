#!/usr/bin/env bash

###
### test.sh: Integrity test of git-follow executable.
###

if [[ -n "$CDPATH" ]]; then
	unset CDPATH
fi

cd ..

TARGET="git-follow"
MDLDIR="/usr/local/etc/git-follow/src"
SRCDIR="src"

SED="/usr/bin/sed"
SEDOPTS="-i ''"
SEDMATCH="s@$MDLDIR@$SRCDIR@g"

# Update 'use lib' directive to 'src' for testing purposes.
eval "$SED $SEDOPTS $SEDMATCH $TARGET"

ERROR=0
TESTS=(
	"--last=5 --no-merges --no-renames"
	"--first --no-patch --branch origin/master"
	"--last --no-merges --no-patch"
	"--func in_array --no-renames"
	"--pickaxe git_track_map_aliases --last --no-patch"
	"--range 954829d 67bfd35 --no-patch"
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

SEDMATCH="s@$SRCDIR@$MDLDIR@g"

# Reset 'use lib' directive to original path.
eval "$SED $SEDOPTS $SEDMATCH $TARGET"

exit $ERROR
