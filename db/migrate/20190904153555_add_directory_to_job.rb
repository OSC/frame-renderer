class AddDirectoryToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :directory, :string
  end
end
