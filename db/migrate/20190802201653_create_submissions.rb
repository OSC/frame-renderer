class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.string :name
      t.string :frames
      t.string :camera
      t.string :renderer
      t.string :extra
      t.string :file
      t.integer :cores
      t.string :cluster
      t.string :status
      t.references :project, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
