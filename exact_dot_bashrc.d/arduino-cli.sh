#!/bin/bash

if type -t arduino-cli > /dev/null 2>&1; then
	# shellcheck disable=SC1090
	. <(arduino-cli completion bash)
fi
