class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.integer :remote_id, null: false, index: true
      t.float :hours, null: false
      t.string :comments
      t.date :spent_on, null: false
      t.datetime :created_on
      t.datetime :updated_on

      t.belongs_to :profile, index: true
      t.belongs_to :project, index: true
      t.belongs_to :issue, index: true

      t.references :time_entry_activity, index: true
    end

    add_index :time_entries, [:profile_id, :remote_id], unique: true
  end
end
