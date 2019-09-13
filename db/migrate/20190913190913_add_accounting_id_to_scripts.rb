class AddAccountingIdToScripts < ActiveRecord::Migration
  def change
    add_column :scripts, :accounting_id, :string
  end
end