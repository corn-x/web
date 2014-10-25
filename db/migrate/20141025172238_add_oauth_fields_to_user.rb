class AddOauthFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :refresh_token, :string
    add_column :users, :expires_in, :string
    add_column :users, :issued_at, :string
  end
end
