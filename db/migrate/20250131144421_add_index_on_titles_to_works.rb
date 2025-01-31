class AddIndexOnTitlesToWorks < ActiveRecord::Migration[7.1]
  def change
    add_index :works, :title, if_not_exists: true, unique: true
  end
end
