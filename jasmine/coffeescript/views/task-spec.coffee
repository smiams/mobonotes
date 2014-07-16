describe "Task View", ->
  task = {}
  App.init()

  beforeEach ->
    loadFixtures("/views/task-list.html")

  describe "_getComponents()", ->
    beforeEach ->
      task = new App.Views.Task
      task.domElement = $("#task-item-2")

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

    it "finds and sets all TaskNotes", ->
      taskNotes = App.Views.TaskNote.findAll()
      task._getComponents()
      expect(task.notes[0].id).toEqual(taskNotes[0].id)
      expect(task.notes[1].id).toEqual(taskNotes[1].id)

    it "sets the TaskNoteCreationForm", ->
      taskNoteCreationForm = App.Views.TaskNoteCreationForm.findAll()[0]
      task._getComponents()
      expect(task.addNoteForm.id).toBe(taskNoteCreationForm.id)

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
    beforeEach ->
      task = new App.Views.Task({id: "task-item-2"})
    
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

  describe "adding and removing TaskNotes", ->
    taskNoteDomElement = {}
    taskNote = {}

    beforeEach ->
      task = new App.Views.Task({id: "task-item-2"})      
      taskNoteDomElement = $("<div id='test-task-note'>a test task note</div>")
      taskNote = new App.Views.TaskNote({domElement: taskNoteDomElement})
    
    describe "addNote()", ->
      it "adds a TaskNote object to the Task's list of notes", ->
        expect(task.notes.length).toBe(2)
        task.addNote(taskNote)
        expect(task.notes.length).toBe(3)

      it "appends the TaskNote's domElement to the Task's domElement", ->
        task.addNote(taskNote)
        expect(task.domElement).toContainElement("#test-task-note")

    describe "removeNote()", ->
      it "removes the TaskNote from the Task's list of notes", ->
        task.removeNote(task.notes[0])
        expect(task.notes.length).toBe(1)

      it "removes the TaskNote's domElement from the Task's domElement", ->
        expect(task.domElement).toContainElement("#first-task-note")

        task.removeNote(task.notes[0])

        expect(task.domElement).not.toContainElement("#first-task-note")
        expect(task.domElement).toContainElement("#second-task-note")