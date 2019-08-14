class Submission < ActiveRecord::Base
  belongs_to :project
  has_many :jobs, dependent: :destroy

  store :job_attrs

  attr_accessor :start_frame, :end_frame, :project_dir

  def staging_template_name
    'video_jobs'
  end

  def submission_template
    'jobs/video_jobs/maya_submit.sh.erb'
  end

  def templated_content
    erb = ERB.new(File.read(submission_template))
    erb.filename = submission_template.to_s
    erb.result(binding)
  end

  def submit(template_view = self)
    success = false

    parse_frames
    script = OodCore::Job::Script.new(content: templated_content)


    true
  end

  def parse_frames
    farray = frames.split('-')

    @start_frame = farray[0]
    @end_frame = farray[1]
  end

end
