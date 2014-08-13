class App.Views.LabelNavigator extends  App.Views.Base
  # hasOne: {labelSelector: "select#label-selector"}

  _getComponents: ->
    @labelSelector = @domElement.find("select#label-selector")

  _attachBehavior: ->
    @labelSelector.on "change", (event) =>
      @parent.navigateToSelectedDateRange()

  getPathForSelectedLabel: ->
    labelId = @labelSelector.val()
    if labelId && labelId.length > 0
      return @basePath + "/" + @labelSelector.val()
    else
      return ""