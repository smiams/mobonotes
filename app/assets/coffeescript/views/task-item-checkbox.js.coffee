class App.Views.TaskItemCheckbox extends App.Views.Checkbox
  _attachBehavior: (domElement) ->
    super(domElement)
    domElement.on "click", ->
      alert("do some ajax...")
      