class AddIrrevantAtToTasks < ActiveRecord::Migration
  def self.up
    change_table :tasks do |t|
      t.datetime :irrelevant_at
    end
  end

  def self.down
    change_table :tasks do |t|
      t.remove :irrelevant_at
    end
  end
end
