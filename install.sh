#!/usr/bin/env bash

set -ve
export EPREFIX="$HOME/Gentoo"
rm -Rf $EPREFIX
export PATH="$EPREFIX/usr/bin:$EPREFIX/bin:$EPREFIX/tmp/usr/bin:$EPREFIX/tmp/bin:$PATH"

export DISTFILES="$EPREFIX/usr/portage/distfiles"
mkdir -p $DISTFILES
mkdir -p $EPREFIX/tmp/usr/portage/
ln -s $DISTFILES $EPREFIX/tmp/usr/portage

curl "http://overlays.gentoo.org/proj/alt/browser/trunk/prefix-overlay/scripts/bootstrap-prefix.sh?format=txt" -o bootstrap-prefix.sh
chmod 755 bootstrap-prefix.sh
./bootstrap-prefix.sh $EPREFIX latest_tree
./bootstrap-prefix.sh $EPREFIX portage

export PORTAGE_BINHOST="http://tinderbox.jolexa.net/amd64-linux-on-gentoo-amd64/"
time FEATURES="-collision-protect" emerge -avg system

cd $EPREFIX/usr/portage/scripts
./bootstrap-prefix.sh $EPREFIX startscript
emerge --sync
