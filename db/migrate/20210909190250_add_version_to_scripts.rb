class AddVersionToScripts < ActiveRecord::Migration[5.2]
  def change
    add_column :scripts, :version, :string
  end
end
