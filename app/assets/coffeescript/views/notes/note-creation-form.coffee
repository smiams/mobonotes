class App.Views.NoteCreationForm extends App.Views.Base
  _getComponents: ->
    @cancelLink = @domElement.find("div.button-container a:contains('cancel')")
    @textarea = @domElement.find("textarea")

  _attachBehavior: ->
    @cancelLink.on "click", (event) =>
      @parent.domElement.hide()

    @domElement.on "submit", (event) =>
      event.preventDefault()

      $.ajax({
          url: this.action,
          type: this.method,
          dataType: "html",
          data: @domElement.serializeArray()
        }).success (data, status, xhr) =>
          @parent.parent.noteList.addNote(new App.Views.Note({domElement: $(data)}))
          @textarea.val("")
          @parent.domElement.hide()
          return xhr

    return @domElement
