#!/usr/bin/env bash

ok() { echo "  [OK]"; }
fail() {
  if [ -z "$1" ]; then clean; fi
  echo "  [FAIL]"; exit 1;
}

clean() {
  if [[ "${CONTAINER_ID}" ]]; then
    echo -n "Removing build container"
    docker rm "${CONTAINER_ID}" >/dev/null &&
      ok || fail 1
  fi
  if [[ "${IMAGE_ID}" ]]; then
    echo -n "Cleaning up image"
    docker image rm "${IMAGE_ID}" >/dev/null &&
      ok || fail 1
  fi
}

# Prepare build container
echo -n "Building image"
IMAGE_ID="$(docker build --quiet .)" &&
  ok || fail
echo -n "Creating build container"
CONTAINER_ID="$(docker create "${IMAGE_ID}")" &&
  ok || fail

# Grab the built files
echo -n "Retrieving build artifacts"
docker cp ${CONTAINER_ID}:/root/build ./ >/dev/null &&
  ok || fail

# Clean up
clean

exit 0
