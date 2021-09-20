class AddTypeToScripts < ActiveRecord::Migration[5.2]
  def change
    add_column :scripts, :type, :text
  end
end
