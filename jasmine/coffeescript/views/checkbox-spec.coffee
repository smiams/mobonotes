describe "Checkbox View", ->
  beforeEach ->
    loadFixtures("/views/checkbox.html")

  describe "_attachBehavior()", ->
    checkbox = {}

    beforeEach ->
      checkbox = new App.Views.Checkbox({id: "checkbox-id"})
      spyOnEvent('#checkbox-id', 'click')

    it "prevents click events from firing in parent elements", ->
      checkbox.domElement.click()
      expect('click').toHaveBeenStoppedOn('#checkbox-id')
