class App.Views.NoteList extends App.Views.Base
  # hasMany: {notes: "App.Views.Note"}

  _getComponents: ->
    @notes = App.Views.Note.findAll(@domElement)

    for note in @notes
      note.parent = this

  addNote: (note) ->
    @notes.push(note)
    note.parent = this
    @domElement.append(note.domElement)
    