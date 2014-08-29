class App.Views.DateRangePicker extends App.Views.Base
  _getComponents: ->
    super()

    dateRangeNavigator = @parent

    options = {
      mode: "range",
      months: 2,
      selected: @formattedStartDate + " - " + @formattedEndDate
      subscribe: {'change': (date, action) ->
        dateRangeNavigator.setStartDate(this._sel[0]._i)
        dateRangeNavigator.setEndDate(this._sel[1]._i)
        dateRangeNavigator.parent.navigateToSelectedDateRange()
      }
    }

    @kalendae = new Kalendae(@id, options)
    @domElement.html(@kalendae.container)

  show: ->
    @domElement.show()

  hide: ->
    @domElement.hide()