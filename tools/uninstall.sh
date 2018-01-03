#!/usr/bin/env bash

set -ex

PREFIX="$1"

if [[ ! -d "$PREFIX" ]]; then
	printf '%s is not a valid directory.\n' "$PREFIX"

	exit 1
fi

TARGET="git-follow"

BINDIR="$PREFIX/bin"
ETCDIR="$PREFIX/etc"
MDLDIR="$ETCDIR/$TARGET"

MANPAGE="$TARGET.1.gz"
MANDEST="$PREFIX/share/man/man1"

RM="rm"
RMFLAGS="-rf"

eval "$RM $RMFLAGS $BINDIR/$TARGET $MANDEST/$MANPAGE"

if [[ -d "$MDLDIR" ]]; then
	eval "$RM $RMFLAGS $MDLDIR"
fi
