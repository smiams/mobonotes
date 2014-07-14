class App.Views.Task extends App.Views.Base
  _getComponents: ->
    @deleteLink = @domElement.find("div.task-controls-container a:contains('delete')")
    @editLink = @domElement.find("div.task-controls-container a:contains('edit')")

    checkbox = App.Views.TaskCheckbox.findAll(@domElement)[0]
    if checkbox
      @checkbox = checkbox
      @checkbox.parent = this

    editForm = App.Views.TaskEditForm.findAll(@domElement)[0]
    if editForm
      @editForm = editForm
      @editForm.parent = this

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
