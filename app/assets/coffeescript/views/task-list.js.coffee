class App.Views.TaskList extends App.Views.Base
  _getComponents: ->
    @taskCreationForm = App.Views.TaskCreationForm.findAll(@domElement)[0]
    @taskCreationForm.parent = this if @taskCreationForm

    @taskItems = App.Views.TaskItem.findAll(@domElement)
    for taskItem in @taskItems
      taskItem.parent = this

  addTaskItem: (taskItem) ->
    @taskItems.push(taskItem)
    taskItem.parent = this
    taskListDomElement = @domElement.find("ol.tasks")
    taskListDomElement.append(taskItem.domElement)

  deleteTaskItem: (taskItem) ->
    for ti, index in @taskItems
      if ti.id == taskItem.id
        ti.domElement.remove()
        @taskItems.splice(index, 1)
        break
