class App.Views.TaskCheckbox extends App.Views.Checkbox
  _attachBehavior: ->
    super()

    @domElement.on "click", =>
      $.ajax({
          data: {selected: this.parent.domElement.hasClass("selected")}
          url: this.url,
          type: this.method,
          dataType: "html"
        }).success (data, status, xhr) =>
          this.parent.replaceDomElement($(data))
          return xhr

    return @domElement