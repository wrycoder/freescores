class CreateWorks < ActiveRecord::Migration[7.1]
  def change
    create_table :works do |t|
      t.string :title
      t.integer :composed_in
      t.string :score_link
      t.string :recording_link
      t.integer :revised_in
      t.integer :genre_id

      t.timestamps
    end
  end
end
