#!/bin/bash

export INTL_PROJECT_ROOT=$(pwd)
cd ./script/generate-options
echo $INTL_PROJECT_ROOT
spago run
