//= require_self
$(document).ready(function () {
  App.init();
  taskLists = App.Views.TaskList.findAll()
  App.Views.Instances = App.Views.Instances.concat(taskLists)
});