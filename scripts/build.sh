#!/usr/bin/env bash

npm install
# Bundle; this is necesssary for ESM support (https://github.com/vercel/pkg/issues/1291#issuecomment-1295792641)
node_modules/.bin/esbuild src/civPatcher.ts --bundle --platform=node --target=node12 --outfile=src/civPatcher.js
# Build the package
node_modules/.bin/pkg src/civPatcher.js -o patch-civ5 -t node12-win
7z a patch-civ5.7z patch-civ5.exe
