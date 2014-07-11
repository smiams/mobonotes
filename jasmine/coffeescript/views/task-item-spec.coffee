describe "Task Item View", ->
  taskItem = {}
  App.init()

  beforeEach ->
    loadFixtures("/views/task-list.html")
    taskItem = new App.Views.TaskItem({id: "task-item-2"})

  describe "_getComponents()", ->
    it "sets the checkbox to a TaskItemCheckbox view object", ->
      checkboxView = App.Views.TaskItemCheckbox.findAll()[0]
      checkboxView.parent = taskItem
      taskItem.checkbox = null
      taskItem._getComponents()
      expect(taskItem.checkbox).toEqual(checkboxView)

    it "sets the editForm to a TaskEditForm view object", ->
      editForm = App.Views.TaskEditForm.findAll()[0]
      editForm.parent = taskItem
      taskItem.editForm = null
      taskItem._getComponents()
      expect(taskItem.editForm).toEqual(editForm)

    it "does not get a TaskItemCheckbox view object if there is no checkbox element in the domElement", ->
      domElement = $("<li id='new-task-item'>new task item without a checkbox</li>")
      taskItem = new App.Views.TaskItem({domElement: domElement})
      taskItem._getComponents()
      expect(taskItem.checkbox).toBe(undefined)

    it "sets the deleteLink to a dom element", ->
      taskItem = new App.Views.TaskItem
      taskItem.domElement = $("#task-item-2")
      taskItem._getComponents()
      expect(taskItem.deleteLink.html().trim()).toBe("delete")

    it "sets the editLink to a dom element", ->
      taskItem = new App.Views.TaskItem
      taskItem.domElement = $("#task-item-2")
      taskItem._getComponents()
      expect(taskItem.editLink.html().trim()).toBe("edit")

  describe "toggleOpen()", ->
    it "adds the 'selected' css class to the domElement", ->
      taskItem.toggleOpen()
      expect(taskItem.domElement).toHaveClass("selected")

    it "adds the App.View object to the App.Views.OpenViews array", ->
      expect(App.Views.OpenViews).not.toContain(taskItem)
      taskItem.toggleOpen()
      expect(App.Views.OpenViews).toContain(taskItem)

    it "removes the 'selected' css class from the domElement", ->
      taskItem.toggleOpen()
      expect(taskItem.domElement).toHaveClass("selected")
      taskItem.toggleOpen()
      expect(taskItem.domElement).not.toHaveClass("selected")

    it "removes the App.View object from the App.Views.OpenViews array", ->
      expect(App.Views.OpenViews).not.toContain(taskItem)
      taskItem.toggleOpen()
      expect(App.Views.OpenViews).toContain(taskItem)
      taskItem.toggleOpen()
      expect(App.Views.OpenViews).not.toContain(taskItem)

    it "only allows one open App.View object at a time", ->
      taskItem1 = new App.Views.TaskItem({id: "task-item-1"})
      expect(App.Views.OpenViews.length).toBe(0)
      taskItem1.toggleOpen()
      expect(App.Views.OpenViews.length).toBe(1)
      expect(App.Views.OpenViews[0]).toBe(taskItem1)

      taskItem.toggleOpen()
      expect(App.Views.OpenViews[0]).toBe(taskItem)
      expect(App.Views.OpenViews.length).toBe(1)

      taskItem.toggleOpen()
      expect(App.Views.OpenViews.length).toBe(0)