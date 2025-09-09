source tests/helpers.sh

### Read a task
begin_test
# Given I have created a task with title "do the thing" and description "to the stuff"
response=$(create_task "do the thing" "to the stuff")
id=$(echo $response | jq .id)
# When I request the task
response=$(get_task $id)
# Then I should receive a task with title "do the thing", description "to the stuff", and completed "false"
expect_task_eq "$response" "do the thing" "to the stuff" "false"
end_test
