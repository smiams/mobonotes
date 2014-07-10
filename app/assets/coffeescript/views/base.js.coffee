class App.Views.Base
  @classIdentifierDOMAttribute = "data-view-class"

  @getClassName: ->
    "App.Views." + @prototype.constructor.name

  @findAll: (contextElement) ->
    className = @getClassName()

    if contextElement
      elements = contextElement.find("[" + @classIdentifierDOMAttribute + "='" + className + "']")
    else
      elements = $.find("[" + @classIdentifierDOMAttribute + "='" + className + "']")

    viewInstances = []
    for element in elements
      viewInstances.push(eval("new " + className + "({domElement: $(element)})"))

    return viewInstances

  constructor: (data) ->
    @initialize(data)

  initialize: (data) ->
    if data
      if data.domElement
        @domElement = data.domElement
        @id = @domElement.attr("id")
      else if data.id
        @id = data.id
        @domElement = @_getDomElement(@id)

    if @domElement
      @_getAttributes(@domElement)
      @_attachBehavior()

    @_getComponents()

  replaceDomElement: (newDomElement) ->
    @domElement.replaceWith(newDomElement)
    @domElement = newDomElement
    @initialize()

  _getAttributes: (domElement) ->
    @_getDomAttributes(domElement)
    @_getDataAttributes(domElement)

  _getDomAttributes: (domElement) ->
    attributes = domElement[0].attributes

    for attribute in attributes
      this[attribute.name] = attribute.value if this[attribute.name] == undefined

    return attributes

  _getDataAttributes: (domElement) ->
    data = domElement.data()

    for key, value of data
      this[key] = value if this[key] == undefined

    return data

  _getDomElement: (id) ->
    return $("#" + id)

  _attachBehavior: ->
    return @domElement

  _getComponents: ->
    return this