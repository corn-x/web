class AddLengthToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :length, :integer
  end
end
