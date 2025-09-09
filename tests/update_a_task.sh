source tests/helpers.sh

### Update a task
begin_test
# Given I have created a task with title "do the thing" and description "to the stuff"
response=$(create_task "do the thing" "to the stuff")
id=$(echo $response | jq .id)
# When I update the task's description to "for the people"
response=$(update_task $id '"description":"for the people"')
# Then I should receive a task with title "do the thing", description "for the people", and completed "false"
expect_task_eq "$response" "do the thing" "for the people" "false"
end_test
