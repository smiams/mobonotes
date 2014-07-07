class App.Views.Checkbox extends App.Views.Base
  _attachBehavior: (domElement) ->
    domElement.on "click", (event) ->
      event.stopPropagation()