class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :remote_id, null: false, index: true
      t.string :first_name
      t.string :last_name
      t.string :email, unique: true
      t.string :api_key, null: false
      t.datetime :created_on

      t.belongs_to :profile, index: true
    end

    add_index :users, [:profile_id, :remote_id], unique: true
  end
end
