describe "Task List View", ->
  taskList = {}
  taskItemDomElement = {}

  beforeEach ->
    loadFixtures("/views/task-list.html")
    taskList = new App.Views.TaskList({id: "task-list"})

  describe "addTaskItem()", ->
    it "adds a TaskItem object to the @taskItems array", ->
      taskItemDomElement = $("<li id='new-task-item-1'>new task item</li>")
      taskItem = new App.Views.TaskItem({domElement: taskItemDomElement})
      taskList.addTaskItem(taskItem)

      expect(taskList.taskItems[taskList.taskItems.length - 1]).toBe(taskItem)

    it "appends the TaskItem's domElement to the TaskList's domElement", ->
      taskItemDomElement = $("<li id='new-task-item-2'>new task item</li>")
      taskItem = new App.Views.TaskItem({domElement: taskItemDomElement})
      taskList.addTaskItem(taskItem)

      expect(taskList.domElement.find("#new-task-item-2")).toEqual(taskItemDomElement)