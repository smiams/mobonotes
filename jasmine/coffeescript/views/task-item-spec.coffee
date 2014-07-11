describe "Task Item View", ->
  taskItem = {}

  beforeEach ->
    loadFixtures("/views/task-list.html")
    taskItem = new App.Views.TaskItem({id: "task-item-2"})

  describe "_attachBehavior()", ->
    it "shows task details when it is clicked", ->
      domElement = taskItem.domElement
      domElement.click()
      expect(domElement).toHaveClass("selected")
      expect(domElement.children(".task-details-container")).toBeVisible()

    it "toggles the task-details-container when clicked", ->
      domElement = taskItem.domElement
      domElement.click()
      expect(domElement).toHaveClass("selected")
      expect(domElement.children(".task-details-container")).toBeVisible()

      domElement.click()
      expect(domElement).not.toHaveClass("selected")
      expect(domElement.children(".task-details-container")).not.toBeVisible()

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