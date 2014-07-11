// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require_self
//= require lib/jquery-1.11.1.min
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

  // I hate binding things onto DOM elements that don't have a corresponding attribute that points back to the JavaScript logc that's doing the binding!!!
  $("body").on("click", function() {
    for(var i=0; i < App.Views.OpenViews.length; i++) {
      openView = App.Views.OpenViews[i];
      openView.toggleOpen();
    };
  });
};