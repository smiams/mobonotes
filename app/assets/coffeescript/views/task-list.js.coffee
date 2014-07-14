class App.Views.TaskList extends App.Views.Base
  _getComponents: ->
    @taskCreationForm = App.Views.TaskCreationForm.findAll(@domElement)[0]
    @taskCreationForm.parent = this if @taskCreationForm

    @tasks = App.Views.Task.findAll(@domElement)
    for task in @tasks
      task.parent = this

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
