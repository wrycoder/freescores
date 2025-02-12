class AddRecordingsAndScores < ActiveRecord::Migration[7.1]
  def change
    remove_column :works, :score_link
    remove_column :works, :recording_link

    create_table :recordings do |t|
      t.string :file_name
      t.string :label
      t.timestamps
      t.references :work
    end

    create_table :scores do |t|
      t.string :file_name
      t.string :label
      t.timestamps
      t.references :work
    end
  end
end
