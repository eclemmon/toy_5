#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
MY_PATH="$SCRIPT_DIR/top_gui.scd"
cd /Applications/SuperCollider.app/Contents/MacOS/
./sclang "$MY_PATH"
