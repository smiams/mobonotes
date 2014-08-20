class App.Views.DateRangeNavigator extends App.Views.Base
  # hasOne: {datesBox: "span#dates"}

  initialize: (data) ->
    super(data)

    if @calculateDayRange() > 1
      @pickerMode = "range"
      @dateRangePickerContainer.show() if @dateRangePickerContainer
    else
      @pickerMode = "single"
      @singleDatePickerContainer.show() if @singleDatePickerContainer

  _getComponents: ->
    @datesBox = @domElement.find("span#dates")
    @changeModeLink = @domElement.find("a#change-mode")

    @datePickerControlsContainer = @domElement.find("div#date-picker-controls-container")
    @singleDatePickerContainer = @domElement.find("div#single-date-picker-container")
    @dateRangePickerContainer = @domElement.find("div#date-range-picker-container")

    @singleDatePicker = @_initializeSingleDatePicker()
    @dateRangePicker = @_initializeDateRangePicker()

    @singleDatePickerContainer.html(@singleDatePicker.container)
    @dateRangePickerContainer.html(@dateRangePicker.container)

  _getDataAttributes: (domElement) ->
    @setStartDate(domElement.data().startDate)
    @setEndDate(domElement.data().endDate)

    super(domElement)
    
  setStartDate: (newStartDate) ->
    @startDate = moment.utc(newStartDate, "YYYY-MM-DD")
    @formattedStartDate = moment(@startDate).format('YYYY-MM-DD')
    @domElement.data().startDate = @formattedStartDate
    @domElement.find("#start-date").html(moment(@startDate).format('MMM Do, YYYY'))

  setEndDate: (newEndDate) ->
    @endDate = moment.utc(newEndDate, "YYYY-MM-DD")
    @formattedEndDate = moment(newEndDate).format('YYYY-MM-DD')
    @domElement.data().endDate = @formattedEndDate
    @domElement.find("#end-date").html(" - " + moment(@endDate).format('MMM Do, YYYY'))

    if @calculateDayRange() > 1
      @domElement.find("#end-date").show()
    else
      @domElement.find("#end-date").hide()

  unsetEndDate: ->
    @endDate = null
    @formattedEndDate = null
    @domElement.removeData("endDate")
    @domElement.find("#end-date").empty()

  calculateDayRange: ->
     Math.ceil((@endDate - @startDate) / 1000 / 60 / 60 / 24) + 1
    
  _attachBehavior: ->
    @datesBox.on "click", (event) =>
      @datePickerControlsContainer.toggle()

    @changeModeLink.on "click", (event) =>
      @_togglePickerMode()
      if !@datePickerControlsContainer.is(":visible")
        @datePickerControlsContainer.toggle()

  _togglePickerMode: ->
    if @pickerMode == "range"
      @changeModeLink.html("choose a date range instead...")
      @singleDatePickerContainer.show()
      @dateRangePickerContainer.hide()
      @pickerMode = "single"
    else
      @changeModeLink.html("choose a single date instead...")
      @dateRangePickerContainer.show()
      @singleDatePickerContainer.hide()
      @pickerMode = "range"

  _initializeSingleDatePicker: ->
    dateRangeNavigator = this

    options = {
      mode: "single",
      selected: @formattedStartDate,
      subscribe: {"change": (date, action) ->
        dateRangeNavigator.setStartDate(this._sel[0]._i)
        dateRangeNavigator.unsetEndDate()
        dateRangeNavigator.parent.navigateToSelectedDateRange()
      }
    }

    new Kalendae(@id, options)

  _initializeDateRangePicker: ->
    dateRangeNavigator = this

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

    new Kalendae(@id, options)

  getPathForSelectedDateRange: ->
    if @calculateDayRange() > 1
      return "/dates/" + @formattedStartDate + "/" + @formattedEndDate
    else
      return "/dates/" + @formattedStartDate