class App.Views.NoteEditWindow extends App.Views.Base
  @hasOne {name: "editForm", class: "App.Views.NoteEditForm"}

  toggle: ->
    @domElement.toggle()