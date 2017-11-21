#!/bin/bash

set -e

compile_lib() {
  local color_green="\033[0;32m"
  local color_reset="\033[0m"

  mkdir -p lib/components lib/services

  # We use tput below to save the cursor position, then restore it later in
  # order to overwrite "processing" messages.

  tput sc
  echo -n "  Compiling src/ to lib/ " >&2
  babel \
    --quiet \
    --out-dir=lib \
    --ignore "**/webpack.config.js,**/test/*.js,**/*.test.js" \
    src
  tput rc
  echo -e "${color_green}✔ Finished compiling src/ to lib/${color_reset}" >&2
}

compile_bundle() {
  mkdir -p dist

  echo -e "\nBuilding bundle...\n" >&2
  webpack --config=src/webpack.config.js

  echo -e "\nBuilding minified bundle...\n" >&2
  NODE_ENV=production webpack --config=src/webpack.config.js
}

compile_lib
compile_bundle
