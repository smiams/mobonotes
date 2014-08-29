class App.Views.TaskCreationForm extends App.Views.Base
  @hasOne {name: "textbox", domSelector: "input[type='text']"}

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