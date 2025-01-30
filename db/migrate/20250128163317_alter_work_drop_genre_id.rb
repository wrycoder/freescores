class AlterWorkDropGenreId < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :works, :genres
  end
end
