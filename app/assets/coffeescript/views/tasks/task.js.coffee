class App.Views.Task extends App.Views.Base
  @hasOne {name: "deleteLink", domSelector: "div.task-controls-container a:contains('delete')"}
  @hasOne {name: "editLink", domSelector: "div.task-controls-container a:contains('edit')"}
  @hasOne {name: "checkbox", class: "App.Views.TaskCheckbox"}
  @hasOne {name: "editForm", class: "App.Views.TaskEditForm"}
  @hasOne {name: "addNoteForm", class: "App.Views.TaskNoteCreationForm"}
  @hasMany {name: "notes", class: "App.Views.TaskNote"}

  _attachBehavior: ->
    super()

    @domElement.on "click", (event) =>
      event.stopPropagation()
      @toggleOpen()

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
            @parent.deleteTask(this)
            return xhr

    return @domElement

  toggleEditActive: ->
    @domElement.toggleClass("edit-active")

  toggleOpen: ->
    if @domElement.hasClass("selected")
      for openView, i in App.Views.OpenViews
        if openView == this
          @domElement.removeClass("selected")
          App.Views.OpenViews.splice(i, 1)
          break
    else
      for openView, i in App.Views.OpenViews
        openView.toggleOpen()

      @domElement.addClass("selected")
      App.Views.OpenViews.push(this)

  addNote: (taskNote) ->
    @notes.push(taskNote)
    taskNote.parent = this
    taskDomElement = @domElement.find(".task-details-container .task-details-content ol.content")
    taskDomElement.append(taskNote.domElement)

    return taskNote

  removeNote: (taskNote) ->
    for note, index in @notes
      if note.id == taskNote.id
        note.domElement.remove()
        @notes.splice(index, 1)
        break