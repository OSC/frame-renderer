class ChangeScheduledHrsName < ActiveRecord::Migration[4.2]
  def change
    change_table :submissions do |t|
      t.rename :scheduled_hrs, :walltime
    end
  end
end
