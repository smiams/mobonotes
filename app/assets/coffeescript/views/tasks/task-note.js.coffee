class App.Views.TaskNote extends App.Views.Base
  @hasOne {name: "editLink", domSelector: ".task-note-controls a:contains('edit')"}
  @hasOne {name: "deleteLink", domSelector: ".task-note-controls a:contains('delete')"}
  @hasOne {name: "editForm", class: "App.Views.TaskNoteEditForm"}

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

  toggleEditActive: ->
    @domElement.toggleClass("edit-active")