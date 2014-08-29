class App.Views.DateRangeNavigator extends App.Views.Base
  @hasOne {name: "datesBox", domSelector: "span#dates"}
  @hasOne {name: "changeModeLink", domSelector: "a#change-mode"}
  @hasOne {name: "datePickerControlsContainer", domSelector: "div#date-picker-controls-container"}
  @hasOne {name: "singleDatePicker", class: "App.Views.SingleDatePicker"}
  @hasOne {name: "dateRangePicker", class: "App.Views.DateRangePicker"}

  initialize: (data) ->
    super(data)

    if @calculateDayRange() > 1
      @pickerMode = "range"
      @dateRangePicker.show() if @dateRangePicker
    else
      @pickerMode = "single"
      @singleDatePicker.show() if @singleDatePicker

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
      @singleDatePicker.show()
      @dateRangePicker.hide()
      @pickerMode = "single"
    else
      @changeModeLink.html("choose a single date instead...")
      @dateRangePicker.show()
      @singleDatePicker.hide()
      @pickerMode = "range"

  getPathForSelectedDateRange: ->
    if @calculateDayRange() > 1
      return "/dates/" + @formattedStartDate + "/" + @formattedEndDate
    else
      return "/dates/" + @formattedStartDate