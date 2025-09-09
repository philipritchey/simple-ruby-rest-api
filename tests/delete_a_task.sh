source tests/helpers.sh

### Delete a task
begin_test
# Given I have created a task
response=$(create_task "try" "harder")
id=$(echo $response | jq .id)
# When I delete the task
response=$(delete_task $id)
# Then I should receive the task
expect_task_eq "$response" "try" "harder" "false"
# And I should not be able to get it again
response=$(get_task $id)
expect_null "response" "$response"
end_test
