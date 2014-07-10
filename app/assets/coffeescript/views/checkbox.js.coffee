class App.Views.Checkbox extends App.Views.Base
  _attachBehavior: ->
    super()

    @domElement.on "click", (event) ->
      event.stopPropagation()

    return @domElement