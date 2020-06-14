#!/bin/sh

set -eux

STATE=$1
URL=$(jq -r '.deployment.statuses_url' $GITHUB_EVENT_PATH)

curl $URL \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/vnd.github.flash-preview+json' \
  -d "{\"state\":\"${STATE}\"}"
