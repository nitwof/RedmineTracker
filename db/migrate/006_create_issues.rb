class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :remote_id, null: false, index: true
      t.string :subject
      t.text :description
      t.date :start_date
      t.integer :done_ratio
      t.datetime :created_on
      t.datetime :updated_on

      t.belongs_to :profile, index: true
      t.belongs_to :project, index: true
      t.belongs_to :parent, index: true

      t.references :priority, index: true
    end

    add_index :issues, [:profile_id, :remote_id], unique: true
  end
end
