require 'sinatra'
require 'sinatra/json'
require 'sequel'
require 'json'

# connect to DB
DB = Sequel.connect('sqlite://api.db')

# create table `tasks` if it doesn't exists
DB.create_table? :tasks do
  primary_key :id
  String :title
  String :description
  Boolean :completed, default: false
end

# Task model to interact with DB
class Task < Sequel::Model
  plugin :json_serializer
end

# Index of all tasks
get '/tasks' do
  tasks = Task.all
  json tasks
end

# Create a task
post '/tasks' do
  data = JSON.parse(request.body.read)
  task = Task.create(title: data['title'], description: data['description'])
  json task
end

# Read a task
get '/tasks/:id' do |id|
  task = Task[id]
  json task
end

# Update a task
put '/tasks/:id' do |id|
  task = Task[id]
  # only update if exists
  if task
    data = JSON.parse(request.body.read)
    # keep values of un-updated attributes
    task.update(
      title: data['title'] || task.title,
      description: data['description'] || task.description,
      completed: data['completed'] || task.completed
    )
  end
  json task
end

# Delete a task
delete '/tasks/:id' do |id|
  task = Task[id]
  # only delete if exists
  if task
    task.delete
  end
  json task
end
