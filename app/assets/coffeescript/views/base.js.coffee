class App.Views.Base
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

  _attachBehavior: (domElement) ->
    return domElement

  _getDomElement: (id) ->
    return $("#" + id)