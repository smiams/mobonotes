class App.Views.TaskItem extends App.Views.Base
  _getComponents: ->
    @deleteLink = @domElement.find("a:contains('delete')")

    checkbox = App.Views.TaskItemCheckbox.findAll(@domElement)[0]
    if checkbox
      @checkbox = checkbox
      @checkbox.parent = this

  _attachBehavior: ->
    super()

    @domElement.on "click", ->
      $(this).toggleClass("selected")

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