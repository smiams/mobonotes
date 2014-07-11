class App.Views.TaskEditForm extends App.Views.Base
  _getComponents: ->
    @cancelLink = @domElement.find("div.button-container a:contains('cancel')")

  _attachBehavior: ->
    @domElement.on "click", (event) =>
      event.stopPropagation()

    @domElement.on "submit", (event) =>
      event.preventDefault()
      data = @domElement.serializeArray()
      data.push({name: "selected", value: this.parent.domElement.hasClass("selected")})

      $.ajax({
          url: this.action,
          type: this.method,
          dataType: "html",
          data: data
        }).success (data, status, xhr) =>
          @parent.replaceDomElement($(data))
          return xhr

    @cancelLink.on "click", (event) =>
      @parent.toggleEditActive()