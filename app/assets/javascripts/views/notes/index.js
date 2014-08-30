//= require_self
$(document).ready(function () {
  // App.Page.hasMany(App.Views.NotesPage);
  App.Views.Instances.push(App.Views.NotesPage.findAll()[0]);
});