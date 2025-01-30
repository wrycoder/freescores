class CreateParts < ActiveRecord::Migration[7.1]
  def change
    create_table :parts do |t|
      t.integer :work_id
      t.integer :instrument_id
      t.integer :quantity

      t.timestamps
    end
  end
end
