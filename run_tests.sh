#!/bin/bash

test_cnt=0
pass_count=0
fail_cnt=0

source tests/get_all_tasks.sh
source tests/create_a_task.sh
source tests/read_a_task.sh
source tests/update_a_task.sh
source tests/delete_a_task.sh

echo
echo -e "\e[34m=== test summary ===\e[0m"
echo "$test_cnt tests"
if (($pass_cnt > 0)); then
    echo -e "\e[32m$pass_cnt passing\e[0m"
fi
if (($fail_cnt > 0)); then
    echo -e "\e[31m$fail_cnt failing\e[0m"
fi
