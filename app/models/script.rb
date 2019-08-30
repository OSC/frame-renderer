require 'securerandom'

class Script < ActiveRecord::Base
  belongs_to :project
  has_many :jobs, dependent: :destroy
  validates :frames, presence: true, format: { with: /\d+\-\d+/ }

  attr_accessor :project_dir

  class << self
    def never_submitted_status
      'not submitted'
    end

    def default_cluster
      'owens'
    end
  end

  def submit
    cluster_ok?
    content = templated_content
    job_id = new_job.submit(content, job_opts)
    job_script(job_id).write(content)
  rescue => e
    errors.add(:name, :blank, message: e.inspect.to_s)
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
    28
  end

  def cluster_ok?
    raise ArgumentError, cluster_error_msg('ruby') if cluster == 'ruby'
    raise ArgumentError, cluster_error_msg('pitzer') if cluster == 'pitzer'
  end

  def cluster_error_msg(cluster)
    "Cannot execute Maya Jobs on #{cluster}, must choose #{default_cluster}"
  end

  private

  def script_template
    'jobs/video_jobs/maya_submit.sh.erb'
  end

  def base_output_dir
    Pathname.new(project_dir).join('batch_jobs').tap { |p| p.mkpath unless p.exist? }
  end

  def job_script(job_id = 'default')
    dir = base_output_dir.join(job_id).tap { |p| p.mkpath unless p.exist? }
    dir.join(job_id + '.script.sh')
  end

  def new_job
    Job.new(
      script_id: id,
      cluster: cluster,
      job_dir: project_dir,
    )
  end

  def templated_content
    erb = ERB.new(File.read(script_template))
    erb.filename = script_template.to_s
    erb.result(binding)
  end

  def job_opts
    {
      job_name: 'maya-render',
      cores: 'cores',
      email_on_terminated: 'email'
    }
  end
end