describe "Base View", ->
  beforeEach ->
    loadFixtures("/views/base.html")

  describe "new()", ->
    it "can be initialized with a dom element id", ->
      baseView = new App.Views.Base({id: "parent-base-view"})
      expect(baseView.id).toBe("parent-base-view")
      expect(baseView.domElement).toEqual($("#parent-base-view"))

    it "can be initialized with a dom element", ->
      baseView = new App.Views.Base({domElement: $("#parent-base-view")})
      expect(baseView.id).toBe("parent-base-view")
      expect(baseView.domElement).toEqual($("#parent-base-view"))

  describe "findAll()", ->
    it "finds all App.Views.Base objects in the DOM", ->
      baseViews = App.Views.Base.findAll()
      expect(baseViews.length).toBe(4)

    it "finds only App.Views.Base objects within a specified DOM context", ->
      parentBaseView = new App.Views.Base({id: "parent-base-view"})
      baseViews = App.Views.Base.findAll(parentBaseView.domElement)
      expect(baseViews.length).toBe(3)