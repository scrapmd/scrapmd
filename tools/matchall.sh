#!/bin/sh

set -eu
PROFILES="development adhoc appstore"
for I in $PROFILES; do
  bundle exec fastlane match $I
done

bundle exec fastlane mac develop_match
bundle exec fastlane mac release_match
