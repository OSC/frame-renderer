class Submission < ActiveRecord::Base
  belongs_to :project
  has_many :jobs, dependent: :destroy

  store :job_attrs

  attr_accessor :start_frame, :end_frame, :project_dir

  def submit
    parse_frames

    job = new_job
    success = job.submit(templated_content)

    success
  end

  private

  def submission_template
    'jobs/video_jobs/maya_submit.sh.erb'
  end

  def new_job
    job = Job.create(job_id: 'NA', status: 'not submitted')
    job.cluster_id = attributes['cluster']
    job
  end

  def templated_content
    erb = ERB.new(File.read(submission_template))
    erb.filename = submission_template.to_s
    erb.result(binding)
  end

  def parse_frames
    farray = frames.split('-')

    @start_frame = farray[0]
    @end_frame = farray[1]
  end

end
