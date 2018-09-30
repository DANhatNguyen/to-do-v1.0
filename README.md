# to-do-v1.0
A simple to do list bash script

## How to use
### Add a task
The task and its deadline must be written between brackets " "

Deadline must be written in the form of DAY/MONTH (i.e: April 3rd is 03/04)

`todo.sh -a [Your task] [Deadline]`
### List all tasks

The color of a task deadline will change from yellow to red on its due date

    todo.sh -l
### Mark a task as done
    todo.sh -d [Task number]
### Undone a task
    todo.sh -u [Task number]
### Remove a task
    todo.sh -r [Task number]
### Clear all tasks
    todo.sh -c
