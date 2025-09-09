source tests/config.sh

begin_test() {
    # drop the database
    rm -rf api.db

    # start the Sinatra server in the background
    rackup -p $PORT &

    # capture the PID
    bgpid=$!

    # wait a moment for the server to start
    sleep 2

    # test status
    failed=false
}

end_test() {
    # kill the backgrounded app
    kill $bgpid

    # update test, pass, and fail counts
    ((test_cnt++))
    if failed; then
        ((fail_cnt++))
    else
        ((pass_cnt++))
    fi
}

get_tasks() {
    curl -sX GET "localhost:$PORT/tasks"
}

get_task() {
    local id=$1
    curl -sX GET "localhost:$PORT/tasks/$id"
}

create_task() {
    local title=$1
    local description=$2
    curl -sX POST -H "Content-Type: application/json" -d '{"title": "'"$title"'", "description": "'"$description"'"}' "localhost:$PORT/tasks"
}

update_task() {
    local id=$1
    local data=$2
    curl -sX PUT -H "Content-Type: application/json" -d '{'"$data"'}' "localhost:$PORT/tasks/$id"
}

delete_task() {
    local id=$1
    curl -sX DELETE "localhost:$PORT/tasks/$id"
}

expect_eq() {
    local attribute=$1
    local actual=$2
    local expected=$3
    if [ "$actual" = "$expected" ]; then
        echo -e "\e[32m[PASS] $attribute is $expected\e[0m"
        return 0
    else
        echo "\e[31m[FAIL] expected $attribute to be $expected, got $actual\e[0m"
        failed=true
        return 1
    fi
}

expect_task_eq() {
    local response=$1
    local expected_title=$2
    local expected_description=$3
    local expected_completed=$4
    actual_title=$(echo $response | jq .title)
    actual_description=$(echo $response | jq .description)
    actual_completed=$(echo $response | jq .completed)
    expect_eq "title" "$actual_title" '"'"$expected_title"'"'
    expect_eq "description" "$actual_description" '"'"$expected_description"'"'
    expect_eq "completed" "$actual_completed" "$expected_completed"
}

expect_empty_list() {
    local attribute=$1
    local actual=$2
    expect_eq "$attribute" "$actual" "[]"
}

expect_null() {
    local attribute=$1
    local actual=$2
    expect_eq "$attribute" "$actual" "null"
}
