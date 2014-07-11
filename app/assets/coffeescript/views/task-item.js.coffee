class App.Views.TaskItem extends App.Views.Base
  _getComponents: ->
    @deleteLink = @domElement.find("div.task-controls-container a:contains('delete')")
    @editLink = @domElement.find("div.task-controls-container a:contains('edit')")

    checkbox = App.Views.TaskItemCheckbox.findAll(@domElement)[0]
    if checkbox
      @checkbox = checkbox
      @checkbox.parent = this

    editForm = App.Views.TaskEditForm.findAll(@domElement)[0]
    if editForm
      @editForm = editForm
      @editForm.parent = this

  _attachBehavior: ->
    super()

    @domElement.on "click", ->
      $(this).toggleClass("selected")

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
            @parent.deleteTaskItem(this)
            return xhr

    return @domElement

  toggleEditActive: ->
    @domElement.toggleClass("edit-active")