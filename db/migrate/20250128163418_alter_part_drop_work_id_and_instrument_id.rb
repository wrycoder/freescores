class AlterPartDropWorkIdAndInstrumentId < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :parts, :works
    add_foreign_key :parts, :instruments
  end
end
