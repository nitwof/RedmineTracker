class CreateTimeEntryActivities < ActiveRecord::Migration
  def change
    create_table :time_entry_activities do |t|
      t.integer :remote_id, null: false, index: true
      t.string :name, null: false

      t.belongs_to :profile, index: true
    end

    add_index :time_entry_activities, [:profile_id, :remote_id], unique: true
  end
end
