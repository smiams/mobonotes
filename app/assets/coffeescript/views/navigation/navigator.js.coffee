class App.Views.Navigator extends App.Views.Base
  @hasOne {name: "dateRangeNavigator", class: "App.Views.DateRangeNavigator"}
  @hasOne {name: "labelNavigator", class: "App.Views.LabelNavigator"}

  navigateToSelectedDateRange: ->
    if @basePath
      window.location = @basePath + @dateRangeNavigator.getPathForSelectedDateRange()
    else
      window.location = @dateRangeNavigator.getPathForSelectedDateRange()