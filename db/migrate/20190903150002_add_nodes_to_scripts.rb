class AddNodesToScripts < ActiveRecord::Migration[4.2]
  def change
    add_column :scripts, :nodes, :integer, default: 1
  end
end
