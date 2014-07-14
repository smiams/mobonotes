describe "Task List View", ->
  taskList = {}
  taskDomElement = {}

  beforeEach ->
    loadFixtures("/views/task-list.html")
    taskList = new App.Views.TaskList({id: "task-list"})

  describe "addTask()", ->
    it "adds a Task object to the @tasks array", ->
      taskDomElement = $("<li id='new-task-item-1'>new task item</li>")
      task = new App.Views.Task({domElement: taskDomElement})
      taskList.addTask(task)

      expect(taskList.tasks[taskList.tasks.length - 1]).toBe(task)

    it "appends the Task's domElement to the TaskList's domElement", ->
      taskDomElement = $("<li id='new-task-item-2'>new task item</li>")
      task = new App.Views.Task({domElement: taskDomElement})
      taskList.addTask(task)

      expect(taskList.domElement.find("#new-task-item-2")).toEqual(taskDomElement)

  describe "deleteTask", ->
    it "deletes the Task object from the tasks array", ->
      expect(taskList.tasks.length).toBe(2)
      taskList.deleteTask(taskList.tasks[1])
      expect(taskList.tasks.length).toBe(1)
      expect(taskList.tasks[0].id).toEqual("task-item-1")

    it "removes the Task domElement from the DOM", ->
      taskToDelete = taskList.tasks[1]
      domElementToDelete = taskToDelete.domElement.clone()
      taskList.deleteTask(taskToDelete)
      expect(taskToDelete.domElement).not.toBeInDOM()
      expect(taskList.tasks[0].domElement).toBeInDOM()