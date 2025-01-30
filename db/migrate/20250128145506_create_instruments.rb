class CreateInstruments < ActiveRecord::Migration[7.1]
  def change
    create_table :instruments do |t|
      t.string :name
      t.integer :ordering
      t.string :family

      t.timestamps
    end
  end
end
