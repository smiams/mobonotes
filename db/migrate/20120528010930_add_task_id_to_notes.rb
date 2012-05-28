class AddTaskIdToNotes < ActiveRecord::Migration
  def self.up
    change_table :notes do |t|
      t.integer :task_id
    end
  end

  def self.down
    change_table :notes do |t|
      t.remove :task_id
    end
  end
end
