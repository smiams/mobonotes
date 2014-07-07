describe "Base View", ->
  describe "new()", ->
    beforeEach ->
      loadFixtures("/views/base.html")

    it "can be initialized with a dom element id", ->
      baseView = new App.Views.Base({id: "base-view-id"})
      expect(baseView.id).toBe("base-view-id")
      expect(baseView.domElement).toEqual($("#base-view-id"))

    it "can be initialized with a dom element", ->
      baseView = new App.Views.Base({domElement: $("#base-view-id")})
      expect(baseView.id).toBe("base-view-id")
      expect(baseView.domElement).toEqual($("#base-view-id"))