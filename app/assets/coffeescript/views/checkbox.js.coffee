class App.Views.Checkbox extends App.Views.Base
#  events: {"click": (event) => do some things...}

  _attachBehavior: ->
    super()

    @domElement.on "click", (event) ->
      event.stopPropagation()

    return @domElement