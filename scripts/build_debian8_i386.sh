#!/bin/bash
set -euo pipefail

REPO_DIR=$(pwd)
mkdir -p out
EXTRA_PACKAGES="$*"

docker build -t dataselect-jessie-i386 -f Dockerfile.jessie-i386 .

docker run --rm -v "$REPO_DIR":/src -w /src dataselect-jessie-i386 bash -lc "
  set -e;
  if [ -n '$EXTRA_PACKAGES' ]; then apt-get update && apt-get install -y --no-install-recommends $EXTRA_PACKAGES; fi;
  export CC=gcc; export CFLAGS='-std=gnu99 -O2';
  if [ -f Makefile ] || [ -f src/Makefile ]; then
    make clean || true;
    make CC=\$CC CFLAGS=\"\$CFLAGS\";
  elif [ -f CMakeLists.txt ]; then
    mkdir -p build; cd build; cmake ..; make;
  elif [ -f go.mod ] || ls *.go 1>/dev/null 2>&1; then
    export GOOS=linux GOARCH=386 CGO_ENABLED=0;
    go build -o dataselect ./...
  else
    echo 'Unknown build system. Inspect manually.'; exit 1;
  fi;
  # copy likely locations to out/
  if [ -f dataselect ]; then cp -v dataselect /src/out/dataselect-debian8-i386; fi
  if [ -f bin/dataselect ]; then cp -v bin/dataselect /src/out/dataselect-debian8-i386; fi
  if [ -f build/dataselect ]; then cp -v build/dataselect /src/out/dataselect-debian8-i386; fi
  if [ -f out/dataselect ]; then cp -v out/dataselect /src/out/dataselect-debian8-i386; fi
"
echo "Built: out/dataselect-debian8-i386 (if build succeeded)"
