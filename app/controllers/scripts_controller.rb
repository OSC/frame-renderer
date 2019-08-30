class ScriptsController < ApplicationController

  def new
    @project = Project.find(params[:project_id])
    init_script
  end

  def create
    @project = Project.find(params[:project_id])
    @script = @project.scripts.build(script_params)

    if @script.save
      redirect_to project_path(@project), notice: 'Job settings successfully created.'
    else
      redirect_to project_path(@project), alert: "Unable to create job settings: #{@script.errors.to_a}"
    end
  end

  def edit
    @project = Project.find(params[:project_id])
    @script = @project.scripts.find(params[:id])
  end

  def update
    @project = Project.find(params[:project_id])
    @script = @project.scripts.find(params[:id])

    if @script.update(script_params)
      redirect_to @project, notice: 'Job settings updated.'
    else
      redirect_to @project, alert: "Unable to update job settings: #{@script.errors.to_a}"
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @script = @project.scripts.find(params[:id])

    if @script.destroy
      redirect_to @project, notice: 'Job settings deleted.'
    else
      redirect_to @project, alert: "Unable to delete job settings: #{@script.errors.to_a}"
    end
  end

  def submit
    @project = Project.find(params[:project_id])
    @script = @project.scripts.find(params[:script_id])
    @script.project_dir = @project.directory # have to pass directory down the stack

    if @script.submit
      redirect_to @project, notice: 'Job successfully submitted'
    else
      redirect_to @project, alert: "Job failed to submit: #{@script.errors.to_a}"
    end
  end
  
  def show
    @project = Project.find(params[:project_id])
    @script = Script.find(params[:id])

    respond_to do |format|
      format.html { render :show }
      format.json { render json: @script }
    end
  end

  def jobs
    get_jobs(params)

    @jobs.map(&:update_status)

    respond_to do |format|
      format.json { render json: @jobs }
    end
  end

  def index
    @project = Project.find(params[:project_id])
    last_jobs = []

    @project.scripts.each do |sub|
      last_job = sub.jobs.first
      last_job&.update_status
      last_jobs.push(last_job) unless last_job.nil?
    end

    respond_to do |format|
      format.json { render json: last_jobs }
    end
  end

  def stop
    get_jobs(params)
    job = Job.find(params[:job_id])

    puts job.inspect.to_s
    job&.stop

    redirect_to @project
  end

  private

  def get_jobs(params)
    @project = Project.find(params[:project_id])
    @script = Script.find(params[:script_id])
    @jobs = @script.jobs.where(script_id: params[:script_id])
  end

  def init_script 
    @script = @project.scripts.build(
      file: @project.directory,
      extra: '-verb -b 1 -ai:lve 0',
      email: true,
      walltime: 1,
      cluster: Script.default_cluster,
      skip_existing: true
    )

  end

  def script_params
    params
      .require(:script)
      .permit(
        :name, :frames, :camera, :file, :cluster, 
        :renderer, :extra, :walltime, :email, :skip_existing
      )
  end

end
