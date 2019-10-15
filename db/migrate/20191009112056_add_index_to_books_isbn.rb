class AddIndexToBooksIsbn < ActiveRecord::Migration[5.1]
  def change
    add_index :books, :isbn, unique: true
  end
end
