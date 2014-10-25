class CreateGoogleCalendars < ActiveRecord::Migration
  def change
    create_table :google_calendars do |t|
      t.references :user, index: true
      t.string :ext_id
      t.datetime :last_synced

      t.timestamps
    end
  end
end
