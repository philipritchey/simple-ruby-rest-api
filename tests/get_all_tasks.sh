source tests/helpers.sh

### Get all tasks
begin_test
# Given no existing tasks
# When I request all tasks
response=$(get_tasks)
# Then I should receive an empty list
expect_empty_list "response" "$response"
end_test
