class AddAscapToWork < ActiveRecord::Migration[7.1]
  def change
    add_column :works, :ascap, :boolean
  end
end
