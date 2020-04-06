require 'securerandom'

class Script < ActiveRecord::Base
  belongs_to :project
  has_many :jobs, dependent: :destroy
  validates :frames, presence: true, format: { with: /\d+\-\d+/ }

  # add accessors: [ :attr1, :attr2 ] etc. when you want to add getters and
  # setters to add new attributes stored in the JSON store
  # don't remove attributes from this list going forward! only deprecate
  store :script_attrs, coder: JSON, accessors: %i[]

  attr_accessor :project_dir

  class << self
    def never_submitted_status
      'not submitted'
    end

    def default_cluster
      Configuration.submit_cluster
    end

    def batch_jobs_dir
      'batch_jobs'
    end
  end

  def submit
    validate_file # fail fast in case a valid file was never chosen
    content = templated_content
    job_id = new_job.submit(content, job_opts)
    job_script(job_id).write(content)
  rescue => e
    clean_up(e, content)
    false
  end

  def start_frame
    frames.split('-').first
  end

  def end_frame
    frames.split('-').last
  end

  def latest_status
    status = jobs&.first&.status
    status.nil? ? Script.never_submitted_status : status
  end

  def latest_job_id
    id = jobs&.first&.job_id
    id.nil? ? Script.never_submitted_status : id
  end

  def latest_id
    id = jobs&.first&.id
    id.nil? ? 0 : id
  end

  def cores
    Configuration.cores
  end

  private

  def validate_file
    if file.nil?
      raise ArgumentError, 'Cannot submit these settings, the file was never chosen'
    elsif !File.exist?(file)
      raise ArgumentError, "Cannot submit these settings, #{file} does not exist"
    end
  end

  def present_accounting_id
    # be sure to return nil and not just empty
    accounting_id.to_s.presence
  end

  def clean_up(err, content)
    errors.add(:name, err.message)
    job_script.write(content)
    puts "failed to submit job because of error #{err.inspect}"
  end

  def job_dir
    base_output_dir.join(job_sub_dir).tap { |p| p.mkpath unless p.exist? }
  end

  def job_sub_dir
    # try to make sure this only gets called once during .new
    @job_sub_dir ||= Time.now.to_i.to_s
  end

  def script_template
    'jobs/video_jobs/maya_submit.sh.erb'
  end

  def base_output_dir
    Pathname.new(project_dir).join('batch_jobs').tap { |p| p.mkpath unless p.exist? }
  end

  def job_script(job_id = 'default')
    job_dir.join(job_id + '.script.sh')
  end

  def new_job
    Job.new(
      script_id: id,
      cluster: cluster,
      directory: job_dir
    )
  end

  def templated_content
    erb = ERB.new(File.read(script_template))
    erb.filename = script_template.to_s
    erb.result(binding)
  end

  def job_array_request
    return '1-' + nodes.to_s if nodes > 1
  end

  def job_opts
    {
      job_name: 'maya-render',
      email_on_terminated: email,
      job_array_request: job_array_request,
      workdir: job_dir,
      accounting_id: present_accounting_id,
      wall_time: walltime * 3600
    }
  end
end
