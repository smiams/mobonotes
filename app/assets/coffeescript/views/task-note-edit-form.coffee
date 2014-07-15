class App.Views.TaskNoteEditForm extends App.Views.Base
  _getComponents: ->
    @cancelLink = @domElement.find("div.button-container a:contains('cancel')")
    @textbox = @domElement.find("textarea")

  _attachBehavior: ->
    @cancelLink.on "click", (event) =>
      event.stopPropagation()
      @parent.toggleEditActive()

    @domElement.on "submit", (event) =>
      event.preventDefault()

      $.ajax({
        url: this.action,
        type: "put",
        dataType: "html",
        data: @domElement.serializeArray()
      }).success (data, status, xhr) =>
        @parent.replaceDomElement($(data))
        return xhr
