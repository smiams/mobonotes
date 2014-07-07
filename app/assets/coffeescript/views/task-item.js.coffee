class App.Views.TaskItem extends App.Views.Base
  constructor: (data) ->
    super(data)
    @_getComponents(@id)

  _attachBehavior: (domElement) ->
    super(domElement)

    domElement.on "click", ->
      $(this).toggleClass("selected")

    return domElement

  _getComponents: (id) ->
    @checkbox = new App.Views.Checkbox({id: @id + "-checkbox"})