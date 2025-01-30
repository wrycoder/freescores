class AddWorkIndexToParts < ActiveRecord::Migration[7.1]
  def change
    add_index :parts, :work_id
    add_index :parts, :instrument_id
  end
end
