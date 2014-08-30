// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require lib/jquery-1.11.1.min
//= require lib/moment.min.js
//= require lib/kalendae.standalone
//= require_self
//= require_tree ../coffeescript

window.App = {};
var App = window.App;
App.Views = {};

App.init = function() {
  App.Views.Instances = [];
  App.Views.OpenViews = [];

  $.ajaxPrefilter(function(options, originalOptions, xhr) {
    var token = $("meta[name=csrf-token]").attr("content");
    if (token) xhr.setRequestHeader('X-CSRF-Token', token);
  });

  // I hate binding things onto DOM elements that don't have a corresponding attribute that points back to the JavaScript logic that's doing the binding!!!
  $("body").on("click", function() {
    for(var i=0; i < App.Views.OpenViews.length; i++) {
      openView = App.Views.OpenViews[i];
      openView.toggleOpen();
    };
  });
};

$(document).ready(function () {
  App.init();
  App.Views.Instances = App.Views.Instances.concat(App.Views.Navigator.findAll());
});