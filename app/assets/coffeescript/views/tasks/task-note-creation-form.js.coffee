class App.Views.TaskNoteCreationForm extends App.Views.Base
  @hasOne {name: "textarea", domSelector: "textarea"}

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
        @textarea.val("")
        return xhr

    return @domElement