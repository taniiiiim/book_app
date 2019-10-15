class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.text :book_name
      t.text :first_name
      t.text :last_name
      t.integer :published
      t.integer :price
      t.text :category
      t.text :abstract
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :books, [:user_id, :created_at]
  end
end
