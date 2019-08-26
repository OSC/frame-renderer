require 'pathname'

class Job < ActiveRecord::Base
  belongs_to :submission

  attr_accessor :job_dir

  def script_name
    'maya_submit.sh'
  end

  class << self
    def default_scope
      # show latest job submission at the top
      order("#{table_name}.id DESC")
    end

  end

  def submit(content = nil, opts = {})
    options = job_opts(opts).merge(content: content)
    script = OodCore::Job::Script.new(options)

    job_id = adapter.submit script # throw exception up the stack
    
    info = adapter.info(job_id)
    update(job_id: job_id, status: info.status.to_s)

    #job_script(job_id).write(content)
    job_id # either throw an exception or you succeeded in submitting
  end

  def update_status
    return if unable_to_update?

    info = adapter.info(job_id)
    update(status: info.status.to_s)
  end

  def base_output_dir
    Pathname.new(job_dir).join('batch_jobs').tap { |p| p.mkpath unless p.exist? }
  end

  private

  def unable_to_update?
    status == 'completed'
  end

  def adapter
    OodAppkit.clusters[cluster].job_adapter
  end

  def job_opts(opts = {})
    opts = opts.to_h.compact.deep_symbolize_keys

    opts.merge(
      workdir: job_dir,
      input_path: job_dir,
    )
  end

end
