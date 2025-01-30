class IndexInstrumentsOnOrdering < ActiveRecord::Migration[7.1]
  def change
    add_index :instruments, :ordering
  end
end
