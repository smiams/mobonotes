describe "Date Range Navigator View", ->
  dateRangeNavigator = {}

  beforeEach ->
    loadFixtures("/views/date-range-navigator.html")
    dateRangeNavigator = new App.Views.DateRangeNavigator({id: "date-range-navigator"})

  describe "setStartDate()", ->
    testStartDate = new Date("2014-07-26 (GMT)")
    dashFormattedDate = "2014-07-26"
    humanFormattedDate = "July 26, 2014"

    it "sets the element's startDate data value in the DOM", ->
      dateRangeNavigator.setStartDate(testStartDate)
      expect(dateRangeNavigator.domElement.data().startDate).toBe(dashFormattedDate)

    it "sets the object's startDate attribute", ->
      dateRangeNavigator.setStartDate(testStartDate)
      expect(dateRangeNavigator.startDate).toBe(testStartDate)

    it "sets the domElement's startDate in the #startDate domElement", ->
      dateRangeNavigator.setStartDate(testStartDate)
      expect(dateRangeNavigator.domElement.children("#start-date").html()).toBe(humanFormattedDate)

  describe "startDate", ->
    it "returns the value in the DOM element's startDate data value", ->
      expect(dateRangeNavigator.startDate.getYear()).toEqual(114)
      expect(dateRangeNavigator.startDate.getMonth()).toEqual(6)
      expect(dateRangeNavigator.startDate.getDate()).toEqual(1)