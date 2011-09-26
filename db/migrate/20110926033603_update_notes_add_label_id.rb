class UpdateNotesAddLabelId < ActiveRecord::Migration
  def self.up
    add_column :notes, :label_id, :integer
  end

  def self.down
    remove_column :notes, :label_id
  end
end
