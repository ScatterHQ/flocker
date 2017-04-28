#!/bin/bash -e

CURRENT_DIR=$(readlink -f $(dirname $0))
OUTPUT_DIR="${CURRENT_DIR}/dist"

if [ ! -d "${OUTPUT_DIR}" ]; then
  mkdir -p "${OUTPUT_DIR}"
fi

pushd "${CURRENT_DIR}" >/dev/null
  docker build  --tag flocker_builder .
  docker run -v ${OUTPUT_DIR}:/opt/flocker/output --rm --privileged flocker_builder
popd >/dev/null

echo "Built files are in ${OUTPUT_DIR}"
