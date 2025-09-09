source tests/helpers.sh

### Create a task
begin_test
# When I create a task with title "do the thing" and description "to the stuff"
response=$(create_task "do the thing" "to the stuff")
# Then I should receive a task with title "do the thing", description "to the stuff", and completed "false"
expect_task_eq "$response" "do the thing" "to the stuff" "false"
end_test
