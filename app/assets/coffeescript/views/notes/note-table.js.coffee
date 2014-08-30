class App.Views.NoteTable extends App.Views.Base
  @hasMany {name: "notes", class: "App.Views.NoteRow"}