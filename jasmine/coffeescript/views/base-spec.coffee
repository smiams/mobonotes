describe "Base View", ->
  beforeEach ->
    loadFixtures("/views/base.html")

  describe "new()", ->
    it "initializes with a dom element id", ->
      baseView = new App.Views.Base({id: "parent-base-view"})
      expect(baseView.id).toBe("parent-base-view")
      expect(baseView.domElement).toEqual($("#parent-base-view"))

  describe "initialize()", ->
    it "initializes with a dom element id", ->
      baseView = new App.Views.Base
      baseView.initialize({id: "parent-base-view"})
      expect(baseView.id).toBe("parent-base-view")
      expect(baseView.domElement).toEqual($("#parent-base-view"))

    it "initializes with a dom element", ->
      baseView = new App.Views.Base
      baseView.initialize({domElement: $("#parent-base-view")})
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

  describe "replaceDomElement()", ->
    it "replaces the old domElement with a new domElement in the DOM", ->
      baseView = new App.Views.Base({domElement: $("#parent-base-view")})
      newDomElement = $("<div id='new-dom-element-from-spec'>a neeeeew doooom</div>")
      baseView.replaceDomElement(newDomElement)
      expect(newDomElement).toBeInDOM()
      expect(newDomElement).toBeMatchedBy("#container-div #new-dom-element-from-spec")

    it "replaces the App.View object's old @domElement with a new @domElement", ->
      baseView = new App.Views.Base({domElement: $("#parent-base-view")})
      newDomElement = $("<div id='new-dom-element-from-spec'>a neeeeew doooom</div>")
      baseView.replaceDomElement(newDomElement)
      expect(baseView.domElement).toBe(newDomElement)

  describe "_getDataAttributes()", ->
    baseView = {}
    domElement = {}

    beforeEach ->
      baseView = new App.Views.Base
      domElement = baseView._getDomElement("parent-base-view")

    it "finds data attributes in the domElement and assigns them as attributes on the App.View object", ->
      baseView._getDataAttributes(domElement)

      expect(baseView.viewClass).toBe("App.Views.Base")
      expect(baseView.testAttrOne).toBe("test attribute 1")
      expect(baseView.testAttrTwo).toBe("test attribute 2")
  
    it "does not assign a data attribute from the domElement if it is already set on the App.View object", ->
      baseView.testAttrOne = "already assigned"
      baseView._getDataAttributes(domElement)

      expect(baseView.testAttrOne).toBe("already assigned")

    it "returns the data hash", ->
      expect(baseView._getDataAttributes(domElement)).toEqual({testAttrTwo: 'test attribute 2', testAttrOne: 'test attribute 1', viewClass: 'App.Views.Base'})

  describe "_getDomAttributes()", ->
    baseView = {}
    domElement = {}

    beforeEach ->
      baseView = new App.Views.Base
      domElement = baseView._getDomElement("parent-base-view")

    it "finds html attributes in the domElement and assigns them as attributes on the App.View object", ->
      baseView._getDomAttributes(domElement)
      expect(baseView["html-test-attr"]).toBe("html test attribute")
      expect(baseView["html-test-attr-2"]).toBe("html test attribute two")

    it "does not assign a html attribute from the domElement if it is already set on the App.View object", ->
      baseView["html-test-attr"] = "already assigned"
      baseView._getDomAttributes(domElement)

      expect(baseView["html-test-attr"]).toBe("already assigned")
