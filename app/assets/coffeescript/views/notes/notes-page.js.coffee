class App.Views.NotesPage extends App.Views.Base
  @hasOne {name: "newNoteLink", domSelector: "#new-note"}
  @hasOne {name: "noteTable", class: "App.Views.NoteTable"}
  @hasOne {name: "noteWindow", class: "App.Views.NoteWindow"}

  _attachBehavior: ->
    @newNoteLink.on "click", (event) =>
      @noteWindow.domElement.show()