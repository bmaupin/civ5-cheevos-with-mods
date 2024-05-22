#!/usr/bin/env bash

nvm use 14
npm install
# Transpile to JavaScript
node_modules/.bin/tsc
# Bundle; this is necesssary for ESM support (https://github.com/vercel/pkg/issues/1291#issuecomment-1295792641)
node_modules/.bin/esbuild src/civPatcher.js --bundle --platform=node --target=node14 --outfile=main.js
# Build the package
node_modules/.bin/pkg main.js -o patch-civ5 -t node14-win
