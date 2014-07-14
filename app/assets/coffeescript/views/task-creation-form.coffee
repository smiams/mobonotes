class App.Views.TaskCreationForm extends App.Views.Base
  _attachBehavior: ->
    super()

    @domElement.on "submit", (event) =>
      event.preventDefault()

      $.ajax({
          url: this.action,
          type: this.method,
          dataType: "html",
          data: @domElement.serializeArray()
        }).success (data, status, xhr) =>
          @parent.addTask(new App.Views.Task({domElement: $(data)}))
          @textbox.val("")
          return xhr

    return @domElement

  _getComponents: ->
    @textbox = @domElement.find("input[type='text']")
    