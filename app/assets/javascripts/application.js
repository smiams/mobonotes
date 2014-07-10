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

  $.ajaxPrefilter(function(options, originalOptions, xhr) {
    var token = $("meta[name=csrf-token]").attr("content");
    if (token) xhr.setRequestHeader('X-CSRF-Token', token);
  });
};