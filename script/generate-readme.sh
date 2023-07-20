#!/bin/bash

cd ./script/generate-readme
spago run > ./../../README.md
# spago script ./script/generate-readme/Main.purs > ./README.md