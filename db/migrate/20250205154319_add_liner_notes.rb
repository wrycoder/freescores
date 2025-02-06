class AddLinerNotes < ActiveRecord::Migration[7.1]
  def change
    create_table(:liner_notes) do |t|
      t.text :note
      t.references :work
    end
  end
end
