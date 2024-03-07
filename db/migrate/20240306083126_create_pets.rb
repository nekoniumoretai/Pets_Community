class CreatePets < ActiveRecord::Migration[6.1]
  def change
    create_table :pets do |t|
      t.string :name, null: false
      t.string :gender, null: false
      t.date :birthday
      t.string :kind, null: false
      t.text :introduction
      t.integer :user_id
      t.timestamps
    end
  end
end
