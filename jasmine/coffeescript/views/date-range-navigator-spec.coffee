describe "Date Range Navigator View", ->
  beforeEach ->
    loadFixtures("/views/navigation.html")

  describe "initialize(data)", ->
    navigationDomElement = {}

    beforeEach ->
      navigationDomElement = $("#navigation")

    it "defaults to the \"single\" pickerMode when the start and end dates are =< 1 day apart", ->
      dateRangeNavigator = App.Views.DateRangeNavigator.findAll()[0]
      expect(dateRangeNavigator.pickerMode).toBe("single")

    it "defaults to the \"range\" pickerMode when the start and end dates are > 1 day apart", ->
      dateRangeNavigatorDomElement = navigationDomElement.find("#date-range-navigator")
      dateRangeNavigatorDomElement.data().endDate = "2014-08-21"

      dateRangeNavigator = App.Views.DateRangeNavigator.findAll()[0]
      expect(dateRangeNavigator.pickerMode).toBe("range")

  describe "setStartDate(newStartDate)", ->
    dateRangeNavigator = {}
    newStartDate = {}

    beforeEach ->
      dateRangeNavigator = App.Views.DateRangeNavigator.findAll()[0]
      dateRangeNavigator.setStartDate("2014-08-19")

    it "sets the startDate instance variable on the DateRangeNavigator object", ->
      expect(dateRangeNavigator.startDate).toEqual(moment.utc("2014-08-19", "YYYY-MM-DD"))

    it "sets the startDate instance variable on the DateRangeNavigator object", ->
      expect(dateRangeNavigator.formattedStartDate).toBe("2014-08-19")

    it "sets the startDate data attribute on the DOM Element", ->
      expect(dateRangeNavigator.domElement.data().startDate).toBe("2014-08-19")

    it "sets and displays a human-formatted startDate in the DOM", ->
      expect(dateRangeNavigator.domElement.find("#start-date").html()).toBe("Aug 19th, 2014")

  describe "setEndDate(newStartDate)", ->
    dateRangeNavigator = {}
    newEndDate = {}

    beforeEach ->
      dateRangeNavigator = App.Views.DateRangeNavigator.findAll()[0]
      dateRangeNavigator.setEndDate("2014-08-21")

    it "sets the endDate instance variable on the DateRangeNavigator object", ->
      expect(dateRangeNavigator.endDate).toEqual(moment.utc("2014-08-21", "YYYY-MM-DD"))

    it "sets the endDate instance variable on the DateRangeNavigator object", ->
      expect(dateRangeNavigator.formattedEndDate).toBe("2014-08-21")

    it "sets the endDate data attribute on the DOM Element", ->
      expect(dateRangeNavigator.domElement.data().endDate).toBe("2014-08-21")

    it "sets and displays a human-formatted endDate in the DOM", ->
      expect(dateRangeNavigator.domElement.find("#end-date").html()).toBe(" - Aug 21st, 2014")


  describe "unsetEndDate()", ->
    dateRangeNavigator = {}

    beforeEach ->
      dateRangeNavigator = App.Views.DateRangeNavigator.findAll()[0]

    it "nullifies the endDate instance variable on the DateRangeNavigator object", ->
      dateRangeNavigator.unsetEndDate()
      expect(dateRangeNavigator.endDate).toBe(null)

    it "nullifies the formattedEndDate instance variable on the DateRangeNavigator object", ->
      dateRangeNavigator.unsetEndDate()
      expect(dateRangeNavigator.formattedEndDate).toBe(null)

    it "clears the human-formatted endDate in the DOM", ->
      dateRangeNavigator.unsetEndDate()
      expect(dateRangeNavigator.domElement.find("#end-date").html()).toBe("")

  describe "calculateDayRange()", ->
    dateRangeNavigator = {}

    beforeEach ->
      dateRangeNavigator = App.Views.DateRangeNavigator.findAll()[0]

    it "returns 1 for startDate and endDate on the same day", ->
      expect(dateRangeNavigator.calculateDayRange()).toBe(1)

    it "returns 2 for startDate and endDate on consecutive days", ->
      dateRangeNavigator.setEndDate(moment.utc("2014-08-21", "YYYY-MM-DD"))
      expect(dateRangeNavigator.calculateDayRange()).toBe(2)

    it "returns 3 for startDate and endDate spanning 3 days", ->
      dateRangeNavigator.setEndDate(moment.utc("2014-08-22", "YYYY-MM-DD"))
      expect(dateRangeNavigator.calculateDayRange()).toBe(3)

  describe "_togglePickerMode()", ->
    dateRangeNavigator = {}

    beforeEach ->
      dateRangeNavigator = App.Views.DateRangeNavigator.findAll()[0]

    describe "when a date range date is selected", ->
      beforeEach ->
        dateRangeNavigator.pickerMode = "range"
        dateRangeNavigator.datePickerControlsContainer.toggle()
        dateRangeNavigator._togglePickerMode()

      it "changes the pickerMode to \"single\"", ->
        expect(dateRangeNavigator.pickerMode).toBe("single")

      it "changes the change-mode link text to \"choose a date range instead...\"", ->
        expect(dateRangeNavigator.domElement.find("#change-mode").html()).toBe("choose a date range instead...")

      it "shows the single date picker", ->
        expect(dateRangeNavigator.singleDatePickerContainer).toBeVisible()

      it "hides the date range picker", ->
        expect(dateRangeNavigator.dateRangePickerContainer).not.toBeVisible()

    describe "when a date range is selected", ->
      beforeEach ->
        dateRangeNavigator.pickerMode = "single"
        dateRangeNavigator.datePickerControlsContainer.toggle()
        dateRangeNavigator._togglePickerMode()

      it "changes the pickerMode to \"range\"", ->
        expect(dateRangeNavigator.pickerMode).toBe("range")

      it "changes the change-mode link text to \"choose a single date instead...\"", ->
        expect(dateRangeNavigator.domElement.find("#change-mode").html()).toBe("choose a single date instead...")

      it "shows the date range picker", ->
        expect(dateRangeNavigator.dateRangePickerContainer).toBeVisible()

      it "hides the single date picker", ->
        expect(dateRangeNavigator.singleDatePickerContainer).not.toBeVisible()

  describe "getPathForSelectedDateRange()", ->
    dateRangeNavigator = {}

    beforeEach ->
      dateRangeNavigator = App.Views.DateRangeNavigator.findAll()[0]

    it "returns the path for a single date", ->
      expect(dateRangeNavigator.getPathForSelectedDateRange()).toBe("/dates/2014-08-20")

    it "returns the path for a date range", ->
      dateRangeNavigator.setEndDate(moment.utc("2014-08-23", "YYYY-MM-DD"))
      expect(dateRangeNavigator.getPathForSelectedDateRange()).toBe("/dates/2014-08-20/2014-08-23")

  describe "_getDataAttributes", ->
    dateRangeNavigator = {}

    beforeEach ->
      dateRangeNavigator = new App.Views.DateRangeNavigator

    it "sets the startDate according to the data attribute on the DOM Element", ->
      dateRangeNavigator.domElement = $("#date-range-navigator")
      dateRangeNavigator.domElement.data().startDate = "2014-08-15"
      dateRangeNavigator._getDataAttributes(dateRangeNavigator.domElement)

      expect(dateRangeNavigator.startDate).toEqual(moment.utc("2014-08-15", "YYYY-MM-DD"))

    it "sets the endDate according to the data attribute on the DOM Element", ->
      dateRangeNavigator.domElement = $("#date-range-navigator")
      dateRangeNavigator.domElement.data().endDate = "2014-08-30"
      dateRangeNavigator._getDataAttributes(dateRangeNavigator.domElement)

      expect(dateRangeNavigator.endDate).toEqual(moment.utc("2014-08-30", "YYYY-MM-DD"))