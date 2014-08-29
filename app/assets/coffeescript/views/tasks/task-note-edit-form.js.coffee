class App.Views.TaskNoteEditForm extends App.Views.Base
  @hasOne {name: "cancelLink", domSelector: "div.button-container a:contains('cancel')"}
  @hasOne {name: "textbox", domSelector: "textarea"}

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
