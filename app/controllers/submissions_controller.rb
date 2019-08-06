class SubmissionsController < ApplicationController
  
  def new
    @project = Project.find(params[:project_id])
    @submission = @project.submissions.build

  end

  def create
    @project = Project.find(params[:project_id])
    @submission = @project.submissions.create(submission_params)

    redirect_to project_path(@project)
  end

  def edit
    @project = Project.find(params[:project_id])
    @submission = @project.submissions.find(params[:id])
  end

  def update
    @project = Project.find(params[:project_id])
    @submission = @project.submissions.find(params[:id])

    @submission.update(submission_params)
    redirect_to @project
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
