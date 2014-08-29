class App.Views.LabelNavigator extends  App.Views.Base
  @hasOne {name: "labelSelector", domSelector: "select#label-selector"}

  _attachBehavior: ->
    @labelSelector.on "change", (event) =>
      window.location = @labelSelector.val()