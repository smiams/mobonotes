class App.Views.NoteList extends App.Views.Base
  @hasMany {name: "notes", class: "App.Views.Note"}

  addNote: (note) ->
    @notes.push(note)
    note.parent = this
    @domElement.append(note.domElement)
    