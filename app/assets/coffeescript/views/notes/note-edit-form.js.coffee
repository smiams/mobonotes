class App.Views.NoteEditForm extends App.Views.Base
  @hasOne {name: "form", domSelector: "form"}
  @hasOne {name: "cancelLink", domSelector: "div.button-container a:contains('cancel')"}
  @hasOne {name: "textarea", domSelector: "textarea"}

  _attachBehavior: ->
    @domElement.on "submit", (event) =>
      event.preventDefault()

      $.ajax({
          url: this.action,
          type: this.method,
          dataType: "html",
          data: @domElement.serializeArray()
        }).success (data, status, xhr) =>
          @parent.parent.replaceDomElement($(data))
          @textarea.val("")
          return xhr

    @cancelLink.on "click", (event) =>
      @parent.domElement.hide()