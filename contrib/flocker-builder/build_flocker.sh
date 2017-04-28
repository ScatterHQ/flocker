#!/bin/bash -e

echo "Building as UID/EUID $UID/$EUID"

BUILD_DIR=/opt/flocker
FLOCKER_SRC_DIR=${BUILD_DIR}/flocker

pushd "${BUILD_DIR}" >/dev/null
  echo "Cloning..."
  git clone https://github.com/scatterhq/flocker

  pushd "${FLOCKER_SRC_DIR}" >/dev/null
    echo "Installing prerequisites"
    # XXX: Not strictly needed but can help if used locally to build
    virtualenv venv
    . venv/bin/activate

    # XXX: netifaces throws an error if it's not installed but adding it to
    #      admin.txt throws an error in Docker build due to duplication
    pip install --requirement requirements/admin.txt && \
    pip install netifaces

    release_id=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
    release_name=$(lsb_release -rs)

    echo "Starting Flocker build in ${FLOCKER_SRC_DIR}..."
    ./admin/build-package --distribution=${release_id}-${release_name} $(pwd)
    echo "Finished Flocker build!"
  popd >/dev/null
popd >/dev/null
