class App.Views.TaskItem extends App.Views.Base
  _attachBehavior: ->
    super()

    @domElement.on "click", ->
      $(this).toggleClass("selected")

    return @domElement

  _getComponents: ->
    @checkbox = App.Views.TaskItemCheckbox.findAll(@domElement)[0]
    @checkbox.parent = this