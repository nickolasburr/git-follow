#!/usr/bin/env bash

set -ex

PREFIX="$1"

if [[ ! -d "$PREFIX" ]]; then
	printf '%s is not a valid directory.\n' "$PREFIX"

	exit 1
fi

TARGET="git-follow"
MANDIR="man"
SRCDIR="src"
DEFDIR="/usr/local"

BINDIR="$PREFIX/bin"
ETCDIR="$PREFIX/etc"
MDLDIR="$ETCDIR/$TARGET"
MDLSRC="$MDLDIR/$SRCDIR"

MANPAGE="$TARGET.1.gz"
MANDEST="$PREFIX/share/man/man1"

INSTALL="/usr/bin/install"
OPTIONS="-c"

CP="/bin/cp"
CPOPTS="-rf"

SED="/usr/bin/sed"
SEDOPTS="-i ''"
SEDMATCH="s@$DEFDIR@$PREFIX@g"

cd ..
cp "$MANDIR/$MANPAGE" "$MANDEST/$MANPAGE"

# Set absolute path for 'use lib' directive.
eval "$SED $SEDOPTS $SEDMATCH $TARGET"
eval "$INSTALL $OPTIONS $TARGET $BINDIR/$TARGET"

if [[ ! -d "$MDLDIR" ]]; then
	mkdir -p "$MDLDIR"
fi

eval "$CP $CPOPTS $SRCDIR $MDLSRC"
