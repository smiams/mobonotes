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
    it "gets a TaskItemCheckbox view object", ->
      checkboxView = App.Views.TaskItemCheckbox.findAll()[0]
      checkboxView.parent = taskItem
      taskItem.checkbox = null
      taskItem._getComponents()
      expect(taskItem.checkbox).toEqual(checkboxView)

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