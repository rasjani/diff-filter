#!/usr/bin/env bash

INPUT_BASE_REF=$1
INPUT_HEAD_REF=$2
INPUT_BASE_DIR=$3
INPUT_DIFF_FILTER=$4

AOUTPUT_TMP=$(
  git diff \
    --name-only \
    --diff-filter=${INPUT_DIFF_FILTER} \
    ${INPUT_BASE_REF} \
    ${INPUT_HEAD_REF} | \
  grep ^${INPUT_BASE_DIR} | \
  xargs -n 1 dirname | \
  awk -F/ '{print $2}' | \
  sort | \
  uniq | \
  jq --raw-input . | \
  jq --slurp . | \
  tr -d "\ \n\r"
)

echo "dirs=${AOUTPUT_TMP}">>${GITHUB_OUTPUT}
