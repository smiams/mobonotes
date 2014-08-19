class App.Views.LabelNavigator extends  App.Views.Base
  # hasOne: {labelSelector: "select#label-selector"}

  _getComponents: ->
    @labelSelector = @domElement.find("select#label-selector")

  _attachBehavior: ->
    @labelSelector.on "change", (event) =>
      window.location = @labelSelector.val()