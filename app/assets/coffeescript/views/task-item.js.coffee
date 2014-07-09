class App.Views.TaskItem extends App.Views.Base
  _attachBehavior: (domElement) ->
    super(domElement)

    domElement.on "click", ->
      $(this).toggleClass("selected")

    return domElement

  _getComponents: ->
    @checkbox = App.Views.TaskItemCheckbox.findAll(@domElement)[0]