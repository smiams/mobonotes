class AddRollingToTasks < ActiveRecord::Migration
  def self.up
    change_table :tasks do |t|
      t.boolean :rolling
    end
  end

  def self.down
    change_table :tasks do |t|
      t.remove :rolling
    end
  end
end
