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
OPTDIR="$PREFIX/opt"
MDLDIR="$OPTDIR/$TARGET"
MDLSRC="$MDLDIR/$SRCDIR"

MANPAGE="$TARGET.1.gz"
MANDEST="$PREFIX/share/man/man1"

INSTALL="/usr/bin/install"
OPTIONS="-c"

CP="/bin/cp"
CPOPTS="-rf"

MKDIR="/bin/mkdir"
MKDIROPTS="-p"

RM="/bin/rm"
RMOPTS="-rf"

SED="/usr/bin/sed"
SEDOPTS="-i ''"
SEDEXPR="s@$DEFDIR@$PREFIX@g"

builtin cd ..
eval "$CP $MANDIR/$MANPAGE $MANDEST/$MANPAGE"

# Set absolute path for 'use lib' directive.
eval "$SED $SEDOPTS $SEDEXPR $TARGET"
eval "$INSTALL $OPTIONS $TARGET $BINDIR/$TARGET"
[[ -d "$MDLDIR" ]] && eval "$RM $RMOPTS $MDLDIR"

eval "$MKDIR $MKDIROPTS $MDLDIR"
eval "$CP $CPOPTS $SRCDIR $MDLSRC"
