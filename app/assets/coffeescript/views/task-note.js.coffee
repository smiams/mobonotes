class App.Views.TaskNote extends App.Views.Base
  _attachBehavior: ->
    @domElement.on "click", (event) =>
      event.stopPropagation()

    @editLink.on "click", (event) =>
      event.stopPropagation()
      @toggleEditActive()

    @deleteLink.on "click", (event) =>
      event.stopPropagation()

      if confirm("Are you sure?")
        $.ajax({
            url: @deleteLink.data("url"),
            type: "delete"
          }).success (data, status, xhr) =>
            @parent.removeNote(this)
            return xhr

  _getComponents: ->
    @editLink = @domElement.find(".task-note-controls a:contains('edit')")
    @deleteLink = @domElement.find(".task-note-controls a:contains('delete')")

    editForm = App.Views.TaskNoteEditForm.findAll(@domElement)[0]
    if editForm
      @editForm = editForm
      @editForm.parent = this

  toggleEditActive: ->
    @domElement.toggleClass("edit-active")