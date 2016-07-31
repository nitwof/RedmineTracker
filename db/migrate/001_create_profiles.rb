class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name, null: false, uniqueness: true
      t.string :url, null: false
      t.string :username
      t.string :password

      t.timestamps
    end
  end
end
