class CreateProjects < ActiveRecord::Migration[4.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.string :directory

      t.timestamps null: false
    end
  end
end
