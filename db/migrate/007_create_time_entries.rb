class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.integer :remote_id, null: false, index: true
      t.float :hours
      t.string :comments
      t.date :spent_on
      t.datetime :created_on
      t.datetime :updated_on

      t.belongs_to :project, index: true
      t.belongs_to :issue, index: true

      t.references :activity, index: true
    end
  end
end
