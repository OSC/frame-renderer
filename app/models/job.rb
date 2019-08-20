class Job < ActiveRecord::Base
  belongs_to :submission

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
    job_script.write(content)
    options = job_opts(opts).merge(content: content)
    script = OodCore::Job::Script.new(options)

    job_id = adapter.submit script # throw exception up the stack
    info = adapter.info(job_id)
    update(job_id: job_id, status: info.status.to_s)
  end

  def update_status
    return if unable_to_update?

    info = adapter.info(job_id)
    update(status: info.status.to_s)
  end

  private

  def cluster
    attributes['cluster']
  end

  def unable_to_update?
    status == 'completed' || status == 'not submitted'
  end

  def adapter
    OodAppkit.clusters[cluster].job_adapter
  end

  def job_dir
    OodAppkit.dataroot.join(id.to_s).tap { |p| p.mkpath unless p.exist? }
  end

  def job_script
    job_dir.join(script_name)
  end

  def user_defined_context_file
    job_dir.join('context.json')
  end

  def job_opts(opts = {})
    work_dir = job_dir
    opts = opts.to_h.compact.deep_symbolize_keys

    opts = opts.merge(
      script_file: job_script,
      workdir: work_dir,
      input_path: work_dir,
      output_path: work_dir.join('output.log'),
      error_path: work_dir.join('error.log')
    )
    opts
  end

end
