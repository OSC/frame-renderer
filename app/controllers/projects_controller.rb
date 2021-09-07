require 'fileutils'

class ProjectsController < ApplicationController

  def new
    @project = Project.new
  end

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
  end

  def create
    @project = ProjectFactory.new_project(project_params)
    if @project.save
      redirect_to @project
    else
      # TODO: show these errors in the webpage.
      Rails.logger.info("could not save project becuase #{@project.errors.full_messages}")
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    @project.update(project_params)

    redirect_to @project
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    redirect_to projects_path
  end

  private

  def project_params
    params
      .require(:project)
      .permit(:name, :description, :directory, :project_type)
  end
end
