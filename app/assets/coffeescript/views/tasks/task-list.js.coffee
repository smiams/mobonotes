class App.Views.TaskList extends App.Views.Base
  @hasOne {name: "taskCreationForm", class: "App.Views.TaskCreationForm"}
  @hasMany {name: "tasks", class: "App.Views.Task"}

  addTask: (task) ->
    @tasks.push(task)
    task.parent = this
    taskListDomElement = @domElement.find("ol.tasks")
    taskListDomElement.append(task.domElement)

  deleteTask: (task) ->
    for tsk, index in @tasks
      if tsk.id == task.id
        tsk.domElement.remove()
        @tasks.splice(index, 1)
        break
