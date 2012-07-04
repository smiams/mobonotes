class AddStartAtAndEndAtToTasks < ActiveRecord::Migration
  def self.up
    change_table :tasks do |t|
      t.datetime :start_at
      t.datetime :end_at
    end
  end

  def self.down
    change_table :tasks do |t|
      t.remove :start_at
      t.remove :end_at
    end
  end
end
