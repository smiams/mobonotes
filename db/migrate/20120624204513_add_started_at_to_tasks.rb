class AddStartedAtToTasks < ActiveRecord::Migration
  def self.up
    change_table :tasks do |t|
      t.datetime :started_at
    end
  end

  def self.down
    change_table :tasks do |t|
      t.remove :started_at
    end
  end
end
