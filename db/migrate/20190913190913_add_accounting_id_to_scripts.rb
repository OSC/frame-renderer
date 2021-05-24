class AddAccountingIdToScripts < ActiveRecord::Migration[4.2]
  def change
    add_column :scripts, :accounting_id, :string
  end
end