#!/bin/bash
limit="${TIMEOUT:-45m}"
exec timeout -sTERM ${limit} "$@"
