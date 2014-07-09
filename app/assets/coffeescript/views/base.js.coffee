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
    if data
      if data.domElement
        @domElement = data.domElement
        @id = @domElement.attr("id")
      else if data.id
        @id = data.id
        @domElement = @_getDomElement(@id)

    if @domElement
      @_attachBehavior(@domElement)

    @_getComponents()

  _getDomElement: (id) ->
    return $("#" + id)

  _attachBehavior: (domElement) ->
    return domElement

  _getComponents: ->
    return this