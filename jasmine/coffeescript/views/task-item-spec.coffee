describe "Task Item View", ->
  taskItem = {}

  beforeEach ->
    loadFixtures("/views/task-item.html")
    taskItem = new App.Views.TaskItem({id: "task-item-id"})

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
    it "gets an App.Views.TaskItemCheckbox view object", ->
      checkboxView = App.Views.TaskItemCheckbox.findAll()[0]
      checkboxView.parent = taskItem
      taskItem.checkbox = null
      taskItem._getComponents()
      expect(taskItem.checkbox).toEqual(checkboxView)