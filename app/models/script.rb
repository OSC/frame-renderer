require 'securerandom'

class Script < ApplicationRecord
  belongs_to :project
  has_many :jobs, dependent: :destroy
  validates :frames, presence: true, format: { with: /\d+\-\d+/ }
  self.inheritance_column = :type

  # add accessors: [ :attr1, :attr2 ] etc. when you want to add getters and
  # setters to add new attributes stored in the JSON store
  # don't remove attributes from this list going forward! only deprecate
  store :script_attrs, coder: JSON, accessors: %i[]

  attr_accessor :project_dir

  class << self
    def never_submitted_status
      'not submitted'
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
    @start_frame ||= frames.split('-').first.to_i
  end

  def end_frame
    @end_frame ||= frames.split('-').last.to_i
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
    raise 'Subclasses need to define `cores`'
  end

  def cluster
    raise 'Subclasses need to define `cluster`'
  end

  def script_template
    raise 'Subclasses need to define `script_template`'
  end

  def renderers
    raise 'Subclasses need to define `renderers`'
  end

  def job_name
    raise 'Subclasses need to define `job_name`'
  end

  def available_versions
    raise 'Subclasses need to define `versions_available`'
  end

  # shell scripts files need to use this method so that we keep backward compatability
  # with jobs that never set versions.
  def module_version
    version.to_s.present? ? version : available_versions.first
  end

  def task_start_frames
    Array.new(tasks).map.with_index(1) do |_, array_id|
      task_start_frame(array_id)
    end
  end

  def task_end_frames
    Array.new(tasks).map.with_index(1) do |_, array_id|
      task_end_frame(array_id)
    end
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
    Rails.logger.error("failed to submit job because of error #{err.inspect}")
    Rails.logger.error(err.backtrace)
  end

  def job_dir
    base_output_dir.join(job_sub_dir).tap { |p| p.mkpath unless p.exist? }
  end

  def job_sub_dir
    # try to make sure this only gets called once during .new
    @job_sub_dir ||= Time.now.to_i.to_s
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
    erb = ERB.new(File.read(script_template), nil, '-')
    erb.filename = script_template.to_s
    erb.result(binding)
  end

  def job_array_request
    return '1-' + nodes.to_s if nodes > 1
  end

  def job_opts
    {
      job_name: job_name,
      email_on_terminated: email,
      job_array_request: job_array_request,
      workdir: job_dir,
      accounting_id: present_accounting_id,
      wall_time: walltime * 3600
    }
  end

  def total_frames
    # need +1 here bc we're always starting at the first frame
    # 20 - 1 = is 20 frames, not 19. even 3-3 is 1 frame (the third)
    @total_frames ||= end_frame - start_frame + 1
  end

  # we originally defined the form as 'nodes' though we actually
  # use a job array with many tasks. Each task has 1 node, so they
  # are 1:1. So while the users see 'node' we actually mean 'task'
  # and it's imperative we keep them 1:1 becuase all these frames/task
  # calculations rely on it.
  def tasks
    nodes
  end

  def task_size
    task_size = (total_frames / tasks).to_i
    task_size.zero? ? 1 : task_size
  end

  def task_start_frame(array_id)
    if tasks == 1
      start_frame
    elsif task_size == 1
      # you have as many nodes as there are tasks
      start_frame.zero? ? array_id - 1 : array_id
    elsif array_id == 1
      start_frame
    else
      task_end_frame(array_id - 1) + 1
    end
  end

  def task_end_frame(array_id)
    if tasks == 1
      end_frame
    elsif last_task?(array_id)
      # last task just picks up all the rest
      end_frame
    elsif task_size == 1
      # you have as many nodes as there are tasks
      start_frame.zero? ? array_id - 1 : array_id
    else
      # have to shift everything -1 because task_size
      # is always > 1 here, but task_size includes start frame
      ef = task_start_frame(array_id) + task_size
      last_task?(array_id) ? ef : ef - 1
    end
  end

  def last_task?(array_id)
    array_id == tasks
  end
end
