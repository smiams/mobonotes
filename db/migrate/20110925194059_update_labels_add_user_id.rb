class UpdateLabelsAddUserId < ActiveRecord::Migration
  def self.up
    add_column :labels, :user_id, :integer
  end

  def self.down
    remove_column :labels, :user_id
  end
end
