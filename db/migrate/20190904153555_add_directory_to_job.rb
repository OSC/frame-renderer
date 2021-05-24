class AddDirectoryToJob < ActiveRecord::Migration[4.2]
  def change
    add_column :jobs, :directory, :string
  end
end
