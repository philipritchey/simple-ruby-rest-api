# Hands-on Demo: RESTful API with Ruby and Sinatra
Based on [Building RESTful APIs with Ruby — A Quick Start Guide](https://medium.com/@AlexanderObregon/building-restful-apis-with-ruby-d5ac54be12e4)

## Create a new directory for your project and navigate to it:
```sh
mkdir ruby-rest-api
code ruby-rest-api
```

## Create a `Gemfile` in the project root and add the following dependencies:
```ruby
source 'https://rubygems.org'

ruby '3.4.1'

gem 'sinatra'
gem 'sequel'
gem 'sqlite3'
gem 'json'
gem 'sinatra-contrib'
```

## Install the gems with Bundler:
```sh
bundle install
```

## Create a file named `app.rb` in the project root and require the necessary libraries:
```ruby
require 'sinatra'
require 'sinatra/json'
require 'sequel'
require 'json'
```

## Set up the database connection using Sequel:
```ruby
DB = Sequel.connect('sqlite://api.db')
```

## Create a table called `tasks` with this schema:
```ruby
DB.create_table? :tasks do
  primary_key :id
  String :title
  String :description
  Boolean :completed, default: false
end
```

## Create a Task model to interact with the database:
```ruby
class Task < Sequel::Model
  plugin :json_serializer
end
```

## Create ICRUD endpoints to interact with the tasks

### Index of all tasks (GET)
```ruby
get '/tasks' do
  tasks = Task.all
  json tasks
end
```

### Create a new task (POST)
```ruby
post '/tasks' do
  data = JSON.parse(request.body.read)
  task = Task.create(title: data['title'], description: data['description'])
  json task
end
```

### Read an existing task (GET)
```ruby
get '/tasks/:id' do |id|
  task = Task[id]
  json task
end
```

### Update an existing task (PUT)
```ruby
put '/tasks/:id' do |id|
  data = JSON.parse(request.body.read)
  task = Task[id]
  # only update if exists
  if task
    # keep values of un-updated attributes
    task.update(
      title: data['title'] || task.title,
      description: data['description'] || task.description,
      completed: data['completed'] || task.completed
    )
  end
  json task
end
```

### Delete a task (DELETE)
```ruby
delete '/tasks/:id' do |id|
  task = Task[id]
  # only delete if exists
  if task
    task.delete
  end
  json task
end
```

## Run the API:
```sh
ruby app.rb
```

## Test / Interact with the API:

### Get all tasks
```gherkin
Given no existing tasks
When I request all tasks
Then I should receive an empty list
```

```sh
curl -sX GET "localhost:4567/tasks"
```

### Create a task
```gherkin
When I create a task with title "do the thing" and description "to the stuff"
Then I should receive a task with title "do the thing", description "to the stuff", and completed "false"
```

```sh
curl -sX POST -H "Content-Type: application/json" -d '{"title": "do the thing", "description": "to the stuff"}' "localhost:4567/tasks"
```

### Read a task
```gherkin
Given I have created a task with title "do the thing" and description "to the stuff"
When I request the task
Then I should receive a task with title "do the thing", description "to the stuff", and completed "false"
```

```sh
curl -sX GET "localhost:4567/tasks/1"
```

### Update a task
```gherkin
Given I have created a task with title "do the thing" and description "to the stuff"
When I update the task's description to "for the people"
Then I should receive a task with title "do the thing", description "for the people", and completed "false"
```

```sh
curl -sX PUT -H "Content-Type: application/json" -d '{"description": "for the people"}' "localhost:4567/tasks/1"
```

### Delete a task
```gherkin
Given I have created a task
When I delete the task
Then I should receive the task
And I should not be able to get it again
```

```sh
curl -sX DELETE "localhost:4567/tasks/1"
```
