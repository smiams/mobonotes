class App.Views.NotesPage extends App.Views.Base
  # hasOne: {newNoteLink: "#new-note",
  #           type: "DOM"
  #           behaviors: {
  #             click: -> @noteWindow.domElement.show(),
  #             submit: -> //do some things...() }

  # hasOne: {noteList: "App.Views.NoteList"}
  # hasOne: {noteWindow: "App.Views.NoteWindow"}

  _getComponents: ->
    @newNoteLink = @domElement.find("#new-note")
    @newNoteLink.parent = this

    @noteList = App.Views.NoteList.findAll(@domElement)[0]
    @noteList.parent = this if @noteList

    @noteWindow = App.Views.NoteWindow.findAll(@domElement)[0]
    @noteWindow.parent = this if @noteWindow

  _attachBehavior: ->
    @newNoteLink.on "click", (event) =>
      @noteWindow.domElement.show()