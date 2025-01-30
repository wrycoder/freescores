class AlterInstrumentRenameOrderingToRank < ActiveRecord::Migration[7.1]
  def change
    rename_column :instruments, :ordering, :rank
  end
end
