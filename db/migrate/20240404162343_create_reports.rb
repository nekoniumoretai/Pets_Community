class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.integer :reporter_id
      t.integer :reported_id
      t.integer :content_id
      t.string :content_type, null: false
      t.integer :reason, null: false
      t.boolean :is_checked, null: false, default: false
      t.timestamps
    end
  end
end
