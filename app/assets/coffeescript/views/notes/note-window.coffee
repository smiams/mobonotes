class App.Views.NoteWindow extends App.Views.Base
  # hasOne: {noteCreationForm: "App.Views.NoteCreationForm"}

  _getComponents: ->
    @noteCreationForm = App.Views.NoteCreationForm.findAll(@domElement)[0]
    @noteCreationForm.parent = this if @noteCreationForm