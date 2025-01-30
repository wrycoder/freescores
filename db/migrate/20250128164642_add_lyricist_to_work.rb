class AddLyricistToWork < ActiveRecord::Migration[7.1]
  def change
    add_column :works, :lyricist, :string
  end
end
