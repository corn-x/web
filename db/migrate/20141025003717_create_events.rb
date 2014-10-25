class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :ext_id
      t.datetime :start_time
      t.datetime :end_time
      t.references :calendar, index: true
      t.string :calendar_type

      t.timestamps
    end
  end
end
