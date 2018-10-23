#!/bin/bash
#
trap 'exit 0' SIGINT

[ -f functions ] && . functions
DEFAULT_CONFIG_FILE="sdh.conf"

init
while true; do
    maintain_list
done
