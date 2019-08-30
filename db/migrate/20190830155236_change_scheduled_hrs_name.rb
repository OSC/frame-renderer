class ChangeScheduledHrsName < ActiveRecord::Migration
  def change
    change_table :submissions do |t|
      t.rename :scheduled_hrs, :walltime
    end
  end
end
