#!/bin/bash
# This script will try to upgrade to latest FreeSMUG OSX Chromium build on your system via the
# command line (right, that means you'll have to open a term and run it from there)
#
# See README for further informations

die() {
    exit 1
}

W="$(whoami)"
TMP="${TMPDIR-/tmp}"
DOWNLOAD_URL="$(curl 'https://sourceforge.net/projects/osxportableapps/rss?path=/Chromium' 2> /dev/null | grep 'guid' | head -1 | sed -e 's/      <guid>\(.*\)<\/guid>/\1/')" || die 'Unable to fetch download URL'
ARCHIVE_NAME="$(echo $DOWNLOAD_URL | cut -d '_' -f 3 | cut -d '/' -f 1 )"
PROC="$(ps aux | grep -i 'Chromium' | grep -iv 'grep' | grep -iv "$0" | wc -l | awk '{print $1}')" || die 'Unable to count running Chromium processes'
INSTALL_DIR='/Applications'
VERSION_LATEST="$(echo $ARCHIVE_NAME | cut -d '.' -f 1-4)"
# Using Chromium's Info.plist to get the SCM Revision.
VERSION_INSTALLED="$(defaults read "${INSTALL_DIR}/Chromium.app/Contents/Info.plist" 'CFBundleShortVersionString' 2> /dev/null)"
INSTALL_DIR='/Applications'
MOUNTPOINT='/Volumes/Chromium'

#erase dots from version numbers for easier comparison
VERSION_LATEST_d="$(echo $VERSION_LATEST | tr -d '.' )"
VERSION_INSTALLED_d="$(echo $VERSION_INSTALLED | tr -d '.')"

# The script should never be run by root
if [ "$W" == 'root' ]; then
  die 
fi

# Checking if latest available build version number is newer than installed one
if (( "$VERSION_LATEST_d" <= "$VERSION_INSTALLED_d" )); then
  die
fi

# Testing if Chromium is currently running
if [ "$PROC" != 0 ]; then
  x=$(osascript -e 'tell app "Finder" to display dialog "There is a Chromium Update available. Press OK to quit Chromium and make the update. Else CANCEL!"'  )
  echo $x
  if [[ $x = "button returned:OK" ]]; then
    osascript -e 'tell application "Chromium" to quit'
    sleep 2 
    if [ "$PROC" != 0 ]; then
      killall Chromium
    fi
  else 
    die
  fi
fi

# Fetching latest archive if not already existing in tmp dir
if [ ! -f "${TMP}/chromium.dmg" ]; then
  curl -L -o "${TMP}/chromium.dmg" "$DOWNLOAD_URL" || die "Unable to fetch archive"
fi

# Deleting previously installed version
if [ -d "${INSTALL_DIR}/Chromium.app" ]; then
  rm -rf "${INSTALL_DIR}/Chromium.app" || die 'Unable to delete previous installed version of Chromium'
fi

# Mount and copy Chromium.app
# http://stackoverflow.com/a/7301584

hdiutil attach -quiet -mountpoint $MOUNTPOINT "${TMP}/chromium.dmg"
for app in `find $MOUNTPOINT -type d -maxdepth 1 -name \*.app `; do
  cp -a "$app" /Applications/
done
hdiutil detach -quiet $MOUNTPOINT

# Cleaning
rm "${TMP}/chromium.dmg"

# Open Chromium
open "${INSTALL_DIR}/Chromium.app"
