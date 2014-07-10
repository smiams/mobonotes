// Generated by CoffeeScript 1.7.1
(function() {
  describe("Task Item View", function() {
    var taskItem;
    taskItem = {};
    beforeEach(function() {
      loadFixtures("/views/task-list.html");
      return taskItem = new App.Views.TaskItem({
        id: "task-item-id"
      });
    });
    describe("_attachBehavior()", function() {
      it("shows task details when it is clicked", function() {
        var domElement;
        domElement = taskItem.domElement;
        domElement.click();
        expect(domElement).toHaveClass("selected");
        return expect(domElement.children(".task-details-container")).toBeVisible();
      });
      return it("toggles the task-details-container when clicked", function() {
        var domElement;
        domElement = taskItem.domElement;
        domElement.click();
        expect(domElement).toHaveClass("selected");
        expect(domElement.children(".task-details-container")).toBeVisible();
        domElement.click();
        expect(domElement).not.toHaveClass("selected");
        return expect(domElement.children(".task-details-container")).not.toBeVisible();
      });
    });
    return describe("_getComponents()", function() {
      it("gets a TaskItemCheckbox view object", function() {
        var checkboxView;
        checkboxView = App.Views.TaskItemCheckbox.findAll()[0];
        checkboxView.parent = taskItem;
        taskItem.checkbox = null;
        taskItem._getComponents();
        return expect(taskItem.checkbox).toEqual(checkboxView);
      });
      return it("does not get a TaskItemCheckbox view object if there is no checkbox element in the domElement", function() {
        var domElement;
        domElement = $("<li id='new-task-item'>new task item</li>");
        taskItem = new App.Views.TaskItem({
          domElement: domElement
        });
        taskItem._getComponents();
        return expect(taskItem.checkbox).toBe(void 0);
      });
    });
  });

}).call(this);
