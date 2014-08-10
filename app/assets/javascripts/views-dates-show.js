//= require_self
$(document).ready(function () {
  App.init();
  taskLists = App.Views.TaskList.findAll()
  App.Views.Instances = App.Views.Instances.concat(taskLists)
  dateRangeNavigator = App.Views.DateRangeNavigator.findAll()
  App.Views.Instances = App.Views.Instances.concat(dateRangeNavigator)
});