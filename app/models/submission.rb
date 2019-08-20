require 'securerandom'

class Submission < ActiveRecord::Base
  belongs_to :project
  has_many :jobs, dependent: :destroy

  attr_accessor :project_dir

  def submit
    new_job.submit(templated_content)
  rescue => e
    errors.add(:name, e.class.to_s, message: e.message)
    false
  end

  def never_submitted_status
    'not submitted'
  end

  def start_frame
    frames.split('-').first
  end

  def end_frame
    frames.split('-').last
  end

  private

  def submission_template
    'jobs/video_jobs/maya_submit.sh.erb'
  end

  def new_job
    Job.new(
      submission_id: attributes['id'],
      cluster: attributes['cluster']
    )
  end

  def templated_content
    erb = ERB.new(File.read(submission_template))
    erb.filename = submission_template.to_s
    erb.result(binding)
  end

end
