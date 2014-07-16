describe "TaskNote View", ->
  taskNote = {}
  App.init()

  beforeEach ->
    loadFixtures("/views/task-list.html")
    taskNote = new App.Views.TaskNote
    taskNote.domElement = $("#first-task-note")

  describe "_getComponents()", ->
    it "finds and sets the editForm", ->
      expect(taskNote.editForm).toBe(undefined)
      taskNote._getComponents()
      expect(taskNote.editForm.id).toBe("first-task-note-edit-form")