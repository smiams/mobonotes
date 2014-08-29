class App.Views.SingleDatePicker extends App.Views.Base
  _getComponents: ->
    super()

    dateRangeNavigator = @parent

    options = {
      mode: "single",
      selected: @formattedStartDate,
      subscribe: {"change": (date, action) ->
        dateRangeNavigator.setStartDate(this._sel[0]._i)
        dateRangeNavigator.unsetEndDate()
        dateRangeNavigator.parent.navigateToSelectedDateRange()
      }
    }

    @kalendae = new Kalendae(@id, options)
    @domElement.html(@kalendae.container)

  show: ->
    @domElement.show()

  hide: ->
    @domElement.hide()