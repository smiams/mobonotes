class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer :label_id
      t.integer :user_id

      t.string :name

      t.datetime :completed_at
      t.datetime :due_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
