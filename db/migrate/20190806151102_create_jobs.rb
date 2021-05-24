class CreateJobs < ActiveRecord::Migration[4.2]
  def change
    create_table :jobs do |t|
      t.string :status
      t.string :job_id
      t.string :cluster
      t.references :submission, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
