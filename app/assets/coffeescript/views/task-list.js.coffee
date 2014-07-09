class App.Views.TaskList extends App.Views.Base
  _getComponents: ->
    @taskItems = App.Views.TaskItem.findAll(@domElement)