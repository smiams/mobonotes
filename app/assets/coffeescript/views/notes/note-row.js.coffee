class App.Views.NoteRow extends App.Views.Base
  @hasOne {name: "editLink", domSelector: "div.links a:contains('edit')"}
  @hasOne {name: "editWindow", class: "App.Views.NoteEditWindow"}

  _attachBehavior: ->
    @editLink.on "click", (event) =>
      @editWindow.toggle()
