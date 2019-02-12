#!/bin/bash
limit="${TIMEOUT:-45m}"
echo "This job will automatically terminate after: ${limit}"
timeout -sKILL ${limit} $@
retval=$?
if [[ ${retval} == 124 ]] || [[ ${retval} == 137 ]]; then
    echo "Job terminated: ${limit} time limit reached"
fi
exit ${retval}
