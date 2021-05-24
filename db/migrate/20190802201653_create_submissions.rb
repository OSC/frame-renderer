class CreateSubmissions < ActiveRecord::Migration[4.2]
  def change
    create_table :submissions do |t|
      t.string :name
      t.string :frames
      t.string :camera
      t.string :renderer
      t.string :extra
      t.string :file
      t.string :cluster
      t.integer :scheduled_hrs
      t.boolean :email
      t.boolean :skip_existing
      t.references :project, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
