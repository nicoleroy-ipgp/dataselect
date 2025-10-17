# Reproduce Debian 8 (Jessie) i386 build for dataselect

1. Make the build script executable:
   chmod +x scripts/build_debian8_i386.sh

2. Run default build:
   ./scripts/build_debian8_i386.sh

3. To install extra dev packages inside the container:
   ./scripts/build_debian8_i386.sh libssl-dev pkg-config

4. Verification (after successful run):
   file out/dataselect-debian8-i386
   readelf -h out/dataselect-debian8-i386 | grep Class
   ldd out/dataselect-debian8-i386 || true

Notes:
- The script builds a Docker image `dataselect-jessie-i386` and runs the container with the current repo mounted at `/src`.
- The script exports CC=gcc and CFLAGS='-std=gnu99 -O2' before running make.
- If the produced binary is not named `dataselect`, check the `out/` directory and decide whether to rename before committing.
