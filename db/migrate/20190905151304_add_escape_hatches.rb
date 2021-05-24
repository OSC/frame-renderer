class AddEscapeHatches < ActiveRecord::Migration[4.2]
  def change
    add_column :jobs, :job_attrs, :text, default: ''
    add_column :scripts, :script_attrs, :text, default: ''
    add_column :projects, :project_attrs, :text, default: ''
  end
end
