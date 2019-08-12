class Submission < ActiveRecord::Base
  belongs_to :project
  has_many :jobs, dependent: :destroy
  has_machete_workflow_of :jobs
  store :job_attrs

  attr_accessor :start_frame, :end_frame, :project_dir

  def staging_template_name
    'video_jobs'
  end

  def build_jobs(staged_dir, job_list = [])
    job_list << OSC::Machete::Job.new(
      script: staged_dir.join('maya_submit.sh'),
      host: 'owens'
    )
  end

  def submit(template_view = self)
    success = false
    staged_dir = stage
    parse_frames

    render_mustache_files(staged_dir, template_view)

    jobs = build_jobs(staged_dir)

    if submit_jobs(jobs)
      puts 'Jobs submitted successfully'
      success = save_jobs(jobs, staged_dir)
    end

    success
  end

  def parse_frames
    farray = frames.split('-')

    start_frame = farray[0]
    end_frame = farray[1]
  end

end
