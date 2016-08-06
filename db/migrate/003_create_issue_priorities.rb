class CreateIssuePriorities < ActiveRecord::Migration
  def change
    create_table :issue_priorities do |t|
      t.integer :remote_id, null: false, index: true
      t.string :name
      t.boolean :default, null: false, default: false

      t.belongs_to :profile, index: true
    end

    add_index :issue_priorities, [:profile_id, :remote_id], unique: true
  end
end
