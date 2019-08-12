class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :status
      t.string :script_name
      t.string :job_path
      t.string :pbsid
      t.references :submission, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
