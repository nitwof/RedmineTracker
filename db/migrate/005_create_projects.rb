class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :remote_id, null: false, index: true
      t.string :name, null: false
      t.string :identifier
      t.text :description
      t.integer :status
      t.datetime :created_on
      t.datetime :updated_on

      t.belongs_to :profile, index: true
      t.belongs_to :parent, index: true
    end

    add_index :projects, [:profile_id, :remote_id], unique: true
  end
end
