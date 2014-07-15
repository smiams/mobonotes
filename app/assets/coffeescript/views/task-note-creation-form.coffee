class App.Views.TaskNoteCreationForm extends App.Views.Base
  _attachBehavior: ->
    @domElement.on "click", (event) =>
      event.stopPropagation()

    @domElement.on "submit", (event) =>
      event.preventDefault()

      $.ajax({
        url: this.action,
        type: this.method,
        dataType: "html",
        data: @domElement.serializeArray()
      }).success (data, status, xhr) =>
        @parent.addNote(new App.Views.TaskNote({domElement: $(data)}))
        @textbox.val("")
        return xhr

    return @domElement

  _getComponents: ->
    @textbox = @domElement.find("textarea")