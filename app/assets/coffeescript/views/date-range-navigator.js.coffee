class App.Views.DateRangeNavigator extends App.Views.Base
  # hasOne: {datesBox: "span#dates"}

  initialize: (data) ->
    super(data)
    if @calculateDayRange() > 1
      @pickerMode = "range"
      @dateRangePickerContainer.show()
    else
      @pickerMode = "single"
      @singleDatePickerContainer.show()

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
    @setEndDate(new Date(domElement.data().endDate + " (GMT)"))
    @setStartDate(new Date(domElement.data().startDate + " (GMT)"))
    super(domElement)
    
  setStartDate: (newStartDate) ->
    @startDate = newStartDate
    @formattedStartDate = $.datepicker.formatDate("yy-mm-dd", @startDate) # can moment.js format dates?
    @domElement.data().startDate = @formattedStartDate
    @domElement.find("#start-date").html($.datepicker.formatDate("MM d, yy", @startDate))

  setEndDate: (newEndDate) ->
    @endDate = newEndDate
    @formattedEndDate = $.datepicker.formatDate("yy-mm-dd", @endDate) # can moment.js format dates?
    @domElement.data().endDate = @formattedEndDate
    @domElement.find("#end-date").html(" - " + $.datepicker.formatDate("MM d, yy", @endDate))
    if @calculateDayRange() > 1
      @domElement.find("#end-date").show()

  unsetEndDate: ->
    @endDate = null
    @formattedEndDate = null
    @domElement.removeData("endDate")
    @domElement.find("#end-date").empty()

  calculateDayRange: ->
     ((@endDate - @startDate) / 1000 / 60 / 60 / 24) + 1
    
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
        dateRangeNavigator.setStartDate(this._sel[0]._d)
        dateRangeNavigator.unsetEndDate()
        dateRangeNavigator.navigateToSelectedRange()
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
        dateRangeNavigator.setStartDate(this._sel[0]._d)
        dateRangeNavigator.setEndDate(this._sel[1]._d)
        dateRangeNavigator.navigateToSelectedRange()
      }
    }
    
    new Kalendae(@id, options)

  navigateToSelectedRange: ->
    if @calculateDayRange() > 1
      window.location.href = "/dates/" + @formattedStartDate + "/" + @formattedEndDate
    else
      window.location.href = "/dates/" + @formattedStartDate