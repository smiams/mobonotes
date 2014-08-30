class App.Views.NoteTable extends App.Views.Base
  @hasMany {name: "notes", class: "App.Views.NoteRow"}

  deleteNote: (note) ->
    for nte, index in @notes
      if nte.id == note.id
        nte.domElement.remove()
        @notes.splice(index, 1)
        break