#!/bin/bash -e

OUTPUT_DIR=/opt/flocker/output
FLOCKER_SRC_DIR=/opt/flocker/flocker

echo "Starting DinD..."
/usr/local/bin/dind_wrapper.sh &

echo "Invoking build script..."
sudo -i -u builder /usr/local/bin/build_flocker.sh

echo "Exporting the packages..."
if [ ! -d "${OUTPUT_DIR}" ]; then
  mkdir -p "${OUTPUT_DIR}"
fi

mv ${FLOCKER_SRC_DIR}/clusterhq-*.deb "${OUTPUT_DIR}"
chmod 666 ${OUTPUT_DIR}/clusterhq-*.deb

echo
echo "Output files:"
ls "${OUTPUT_DIR}"
