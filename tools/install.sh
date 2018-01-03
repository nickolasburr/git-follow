#!/usr/bin/env bash

set -ex

PREFIX="$1"

if [[ ! -d "$PREFIX" ]]; then
	printf '%s is not a valid directory.\n' "$PREFIX"

	exit 1
fi

BINDIR="$PREFIX/bin"

TARGET="git-follow"
MANPAGE="$TARGET.1.gz"
MANDEST="$PREFIX/share/man/man1"

INSTALL="/usr/bin/install"
OPTIONS="-c"

cd ..

cp "man/$MANPAGE" "$MANDEST/$MANPAGE"

eval "$INSTALL $OPTIONS $TARGET $BINDIR/$TARGET"
