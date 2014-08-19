class App.Views.Navigator extends App.Views.Base
  # hasOne: {"dateRangeNavigator": App.Views.DateRangeNavigator}
  # hasOne: {"labelNavigator": App.Views.LabelNavigator}

  _getComponents: ->
    @dateRangeNavigator = App.Views.DateRangeNavigator.findAll()[0]
    if @dateRangeNavigator
      @dateRangeNavigator.parent = this

    @labelNavigator = App.Views.LabelNavigator.findAll()[0]
    if @labelNavigator
      @labelNavigator.parent = this

  navigateToSelectedDateRange: ->
    if @basePath
      window.location = @basePath + @dateRangeNavigator.getPathForSelectedDateRange()
    else
      window.location = @dateRangeNavigator.getPathForSelectedDateRange()