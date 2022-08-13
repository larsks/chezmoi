#!/bin/bash

if [ -t 0 ]; then
	GPG_TTY="$(tty)"
	export GPG_TTY
fi
