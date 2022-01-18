#!/bin/sh

realpath() {
  OURPWD=$PWD
  cd "$(dirname "$1")"
  LINK=$(readlink "$(basename "$1")")
  while [ "$LINK" ]; do
    cd "$(dirname "$LINK")"
    LINK=$(readlink "$(basename "$1")")
  done
  REALPATH="$PWD/$(basename "$1")"
  cd "$OURPWD"
  echo "$REALPATH"
}

BIN_DIR="$(dirname "$(realpath "$0")")"
FLOWFORGE_HOME="$(dirname "$BIN_DIR")"
cd $FLOWFORGE_HOME
export FLOWFORGE_HOME
./app/node_modules/.bin/flowforge
