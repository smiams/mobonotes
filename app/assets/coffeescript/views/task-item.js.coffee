class App.Views.TaskItem extends App.Views.Base
  _attachBehavior: ->
    super()

    @domElement.on "click", ->
      $(this).toggleClass("selected")

    return @domElement

  _getComponents: ->
    checkbox = App.Views.TaskItemCheckbox.findAll(@domElement)[0]
    if checkbox
      @checkbox = checkbox
      @checkbox.parent = this