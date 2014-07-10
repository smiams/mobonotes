// Generated by CoffeeScript 1.7.1
(function() {
  describe("Task Item View", function() {
    var taskItem;
    taskItem = {};
    beforeEach(function() {
      loadFixtures("/views/task-item.html");
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
      return it("gets an App.Views.TaskItemCheckbox view object", function() {
        var checkboxView;
        checkboxView = App.Views.TaskItemCheckbox.findAll()[0];
        checkboxView.parent = taskItem;
        taskItem.checkbox = null;
        taskItem._getComponents();
        return expect(taskItem.checkbox).toEqual(checkboxView);
      });
    });
  });

}).call(this);
