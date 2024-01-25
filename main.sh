#!/usr/bin/env bash

INPUT_BASE_DIR=$1
INPUT_DIFF_FILTER=$2

if [ "${GITHUB_EVENT_NAME}" == "pull_request" ]; then
  BASE_REF=$(git rev-parse origin/"${GITHUB_BASE_REF}")
  HEAD_REF=$(git rev-parse HEAD)
elif  [ "${GITHUB_EVENT_NAME}" == "push" ]; then
  BASE_REF=HEAD
  HEAD_REF="HEAD^"
else
  echo "${GITHUB_ACTION} action supports only 'pull_request' and 'commit' events."
  # TODO: Should exit here with error ?
  BASE_REF=HEAD
  HEAD_REF=HEAD
fi

AOUTPUT_TMP=$(
  git \
    --no-pager \
    diff \
    --name-only \
    --diff-filter="${INPUT_DIFF_FILTER}" \
    "${BASE_REF}" \
    "${HEAD_REF}" | \
  grep ^"${INPUT_BASE_DIR}" | \
  xargs -n 1 dirname | \
  awk -F/ '{print $2}' | \
  sort | \
  uniq | \
  jq --raw-input . | \
  jq --slurp . | \
  tr -d "\ \n\r"
)

echo "dirs=${AOUTPUT_TMP}">>"${GITHUB_OUTPUT}"
