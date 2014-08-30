class App.Views.NoteRow extends App.Views.Base
  @hasOne {name: "editLink", domSelector: "div.links a:contains('edit')"}
  @hasOne {name: "editWindow", class: "App.Views.NoteEditWindow"}
  @hasOne {name: "deleteLink", domSelector: "div.links a:contains('delete')"}

  _attachBehavior: ->
    @editLink.on "click", (event) =>
      @editWindow.toggle()

    @deleteLink.on "click", (event) =>
      event.stopPropagation()

      if confirm("Are you sure?")
        $.ajax({
            url: @deleteLink.data("url"),
            type: "delete"
          }).success (data, status, xhr) =>
            @parent.deleteNote(this)
            return xhr
