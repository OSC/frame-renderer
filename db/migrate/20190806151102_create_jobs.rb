class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :status
      t.string :job_id
      t.references :submission, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
