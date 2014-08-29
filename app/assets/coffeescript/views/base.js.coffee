class App.Views.Base
  @classIdentifierDOMAttribute = "data-view-class"

  @hasOne: (configHash) ->
    if @prototype.constructor.singleChildren == undefined
      @prototype.constructor.singleChildren = []

    @prototype.constructor.singleChildren.push(configHash)

  @hasMany: (configHash) ->
    if @prototype.constructor.multiChildren == undefined
      @prototype.constructor.multiChildren = []

    @prototype.constructor.multiChildren.push(configHash)

  @getClassName: ->
    "App.Views." + @prototype.constructor.name

  @findAll: (parent) ->
    className = @getClassName()

    if parent
      elements = parent.domElement.find("[" + @classIdentifierDOMAttribute + "='" + className + "']")
    else
      elements = $.find("[" + @classIdentifierDOMAttribute + "='" + className + "']")

    viewInstances = []
    for element in elements
      dataHash = {domElement: $(element)}
      dataHash.parent = parent if parent
      viewInstance = eval("new " + className + "(dataHash)")
      viewInstances.push(viewInstance)

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

      this.parent = data.parent if data.parent

    if @domElement
      @_getAttributes(@domElement)
    @_getComponents()
    @_attachBehavior()

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
    if @constructor.singleChildren
      for configHash in @constructor.singleChildren
        if configHash.class
          @[configHash.name] = eval(configHash.class + ".findAll(this)[0]")        
        else if configHash.domSelector
          @[configHash.name] = @domElement.find(configHash.domSelector)

    if @constructor.multiChildren
      for configHash in @constructor.multiChildren
        if configHash.class
          @[configHash.name] = eval(configHash.class + ".findAll(this)")
        else if configHash.domSelector
          @[configHash.name] = @domElement.find(configHash.domSelector)

    return this