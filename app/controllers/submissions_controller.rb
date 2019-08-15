class SubmissionsController < ApplicationController

  def new
    @project = Project.find(params[:project_id])
    @submission = @project.submissions.build
    @submission.file = @project.directory
    @submission.cores = '28'
  end

  def create
    @project = Project.find(params[:project_id])

    if @submission = @project.submissions.create(submission_params)
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
    @submission = @project.submissions.find(params[:id])

    respond_to do |format|
      format.html { render :show }
      format.json { render json: @submission }
    end
  end

  def submission_params
    params
      .require(:submission)
      .permit(
        :name, :frames, :camera, :renderer,
        :extra, :file, :cores, :cluster
      )
  end

end
