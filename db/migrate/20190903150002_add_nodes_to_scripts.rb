class AddNodesToScripts < ActiveRecord::Migration
  def change
    add_column :scripts, :nodes, :integer, default: 1
  end
end
