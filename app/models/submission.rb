require 'securerandom'

class Submission < ActiveRecord::Base
  belongs_to :project
  has_many :jobs, dependent: :destroy

  attr_accessor :project_dir

  class << self
    def never_submitted_status
      'not submitted'
    end
  end

  def submit
    content = templated_content
    job_id = new_job.submit(content, job_opts)
    job_script(job_id).write(content)
  rescue => e
    errors.add(:name, :blank, message: e.inspect.to_s)
    puts 'error while submitting: ' + e.inspect.to_s
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
    status.nil? ? Submission.never_submitted_status : status
  end

  private

  def submission_template
    'jobs/video_jobs/maya_submit.sh.erb'
  end

  def base_output_dir
    Pathname.new(project_dir).join('batch_jobs', id.to_s).tap { |p| p.mkpath unless p.exist? }
  end

  def job_script(job_id = 'default')
    dir = base_output_dir.join(job_id).tap { |p| p.mkpath unless p.exist? }
    dir.join(job_id + '.script.sh')
  end

  def new_job
    Job.new(
      submission_id: id,
      cluster: cluster,
      job_dir: project_dir,
    )
  end

  def templated_content
    erb = ERB.new(File.read(submission_template))
    erb.filename = submission_template.to_s
    erb.result(binding)
  end

  def job_opts
    {
      job_name: 'maya-render',
      cores: attributes['cores'],
      email_on_terminated: attributes['email']
    }
  end
end