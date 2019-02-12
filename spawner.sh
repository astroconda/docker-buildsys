#!/bin/bash
limit="${TIMEOUT:-45m}"
echo "This job will automatically terminate after: ${limit}"
timeout -sTERM ${limit} $@
retval=$?
if [[ ${retval} == 124 ]]; then
    echo "Job terminated: ${limit} time limit reached"
fi
exit ${retval}
