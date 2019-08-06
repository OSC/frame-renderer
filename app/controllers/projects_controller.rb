require 'fileutils'

class ProjectsController < ApplicationController

  def new
    @project = Project.new
  end

  def index
    @projects = Project.preload.all
  end

  def show
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(project_params)
    init_project_dir @project
    @project.save

    make_project_dir @project.directory

    redirect_to @project
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    @project.update(project_params)

    make_project_dir @project.directory

    redirect_to @project
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    redirect_to projects_path
  end

  def submission_edit
    @project = Project.find(params[:id])
  end

  def submit
    
  end

  private

  def project_params
    params
      .require(:project)
      .permit(:name, :description, :directory)
  end

  def init_project_dir prj
    if prj.directory.blank?
      prj.directory =
        ENV['HOME'] +
        '/ondemand/data/dev/video-processing/' +
        prj.name
    end
  end

  def make_project_dir dir
    FileUtils.mkdir_p dir unless File.directory?(dir)
  end
end
