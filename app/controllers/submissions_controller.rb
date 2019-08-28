class SubmissionsController < ApplicationController

  def new
    @project = Project.find(params[:project_id])
    init_submission
  end

  def create
    @project = Project.find(params[:project_id])
    @submission = @project.submissions.build(submission_params)

    if @submission.save
      redirect_to project_path(@project), notice: 'Submission successfully created.'
    else
      redirect_to project_path(@project), alert: "Unable to create submission: #{@submission.errors.to_a}"
    end
  end

  def edit
    @project = Project.find(params[:project_id])
    @submission = @project.submissions.find(params[:id])
  end

  def update
    @project = Project.find(params[:project_id])
    @submission = @project.submissions.find(params[:id])

    if @submission.update(submission_params)
      redirect_to @project, notice: 'Submission updated.'
    else
      redirect_to @project, alert: "Unable to update submission: #{@submission.errors.to_a}"
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @submission = @project.submissions.find(params[:id])

    if @submission.destroy
      redirect_to @project, notice: 'Submission deleted.'
    else
      redirect_to @project, alert: "Unable to delete submission: #{@submission.errors.to_a}"
    end
  end

  def submit
    @project = Project.find(params[:project_id])
    @submission = @project.submissions.find(params[:submission_id])
    @submission.project_dir = @project.directory

    if @submission.submit
      redirect_to @project, notice: 'Job submission succeeded'
    else
      redirect_to @project, alert: "Job submission failed #{@submission.errors.to_a}"
    end
  end
  
  def show
    @project = Project.find(params[:project_id])
    @submission = Submission.find(params[:id])

    respond_to do |format|
      format.html { render :show }
      format.json { render json: @submission }
    end
  end

  def jobs
    @project = Project.find(params[:project_id])
    @submission = Submission.find(params[:submission_id])
    @jobs = @submission.jobs.where(submission_id: params[:submission_id])

    @jobs.map(&:update_status)

    respond_to do |format|
      format.json { render json: @jobs }
    end
  end

  def index
    @project = Project.find(params[:project_id])
    last_jobs = []

    @project.submissions.each do |sub|
      last_job = sub.jobs.first
      last_job&.update_status
      last_jobs.push(last_job) unless last_job.nil?
    end

    respond_to do |format|
      format.json { render json: last_jobs }
    end
  end

  private 

  def init_submission 
    @submission = @project.submissions.build(
      file: @project.directory,
      extra: '-verb -b 1 -ai:lve 0',
      email: true,
      scheduled_hrs: 1,
      cluster: Submission.default_cluster,
      skip_existing: true
    )

  end

  def submission_params
    params
      .require(:submission)
      .permit(
        :name, :frames, :camera, :file, :cluster, 
        :renderer, :extra, :scheduled_hrs, :email, :skip_existing
      )
  end

end
