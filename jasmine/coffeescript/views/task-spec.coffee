describe "Task Item View", ->
  task = {}
  App.init()

  beforeEach ->
    loadFixtures("/views/task-list.html")
    task = new App.Views.Task({id: "task-item-2"})

  describe "_getComponents()", ->
    it "sets the checkbox to a TaskCheckbox view object", ->
      checkboxView = App.Views.TaskCheckbox.findAll()[0]
      checkboxView.parent = task
      task.checkbox = null
      task._getComponents()
      expect(task.checkbox).toEqual(checkboxView)

    it "sets the editForm to a TaskEditForm view object", ->
      editForm = App.Views.TaskEditForm.findAll()[0]
      editForm.parent = task
      task.editForm = null
      task._getComponents()
      expect(task.editForm).toEqual(editForm)

    it "does not get a TaskCheckbox view object if there is no checkbox element in the domElement", ->
      domElement = $("<li id='new-task-item'>new task item without a checkbox</li>")
      task = new App.Views.Task({domElement: domElement})
      task._getComponents()
      expect(task.checkbox).toBe(undefined)

    it "sets the deleteLink to a dom element", ->
      task = new App.Views.Task
      task.domElement = $("#task-item-2")
      task._getComponents()
      expect(task.deleteLink.html().trim()).toBe("delete")

    it "sets the editLink to a dom element", ->
      task = new App.Views.Task
      task.domElement = $("#task-item-2")
      task._getComponents()
      expect(task.editLink.html().trim()).toBe("edit")

  describe "toggleOpen()", ->
    it "adds the 'selected' css class to the domElement", ->
      task.toggleOpen()
      expect(task.domElement).toHaveClass("selected")

    it "adds the App.View object to the App.Views.OpenViews array", ->
      expect(App.Views.OpenViews).not.toContain(task)
      task.toggleOpen()
      expect(App.Views.OpenViews).toContain(task)

    it "removes the 'selected' css class from the domElement", ->
      task.toggleOpen()
      expect(task.domElement).toHaveClass("selected")
      task.toggleOpen()
      expect(task.domElement).not.toHaveClass("selected")

    it "removes the App.View object from the App.Views.OpenViews array", ->
      expect(App.Views.OpenViews).not.toContain(task)
      task.toggleOpen()
      expect(App.Views.OpenViews).toContain(task)
      task.toggleOpen()
      expect(App.Views.OpenViews).not.toContain(task)

    it "only allows one open App.View object at a time", ->
      task1 = new App.Views.Task({id: "task-item-1"})
      expect(App.Views.OpenViews.length).toBe(0)
      task1.toggleOpen()
      expect(App.Views.OpenViews.length).toBe(1)
      expect(App.Views.OpenViews[0]).toBe(task1)

      task.toggleOpen()
      expect(App.Views.OpenViews[0]).toBe(task)
      expect(App.Views.OpenViews.length).toBe(1)

      task.toggleOpen()
      expect(App.Views.OpenViews.length).toBe(0)