#!/usr/bin/env bash
set -ex

PREFIX="$1"

if [[ ! -d "$PREFIX" ]]; then
	printf '%s is not a valid directory.\n' "$PREFIX"
	exit 1
fi

TARGET="git-follow"

BINDIR="$PREFIX/bin"
OPTDIR="$PREFIX/opt"
MDLDIR="$OPTDIR/$TARGET"

MANPAGE="$TARGET.1.gz"
MANDEST="$PREFIX/share/man/man1"

RM="rm"
RMOPTS="-rf"

eval "$RM $RMOPTS $BINDIR/$TARGET $MANDEST/$MANPAGE"
[[ -d "$MDLDIR" ]] && eval "$RM $RMOPTS $MDLDIR"
