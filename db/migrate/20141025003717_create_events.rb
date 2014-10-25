class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :id
      t.datetime :start_time
      t.datetime :end_time
      t.references :calendar, index: true

      t.timestamps
    end
  end
end
