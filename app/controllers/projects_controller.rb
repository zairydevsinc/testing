class ProjectsController < ApplicationController

  def index
    if current_user.usertype == 'Developer'
      @projects = current_user.project_assigned
    elsif current_user.usertype == 'QA'
      @projects = Project.all
    else
      @projects = current_user.projects.all
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = current_user.projects.new
    authorize @project
  end

  def edit
    @project = Project.find(params[:id])
    authorize @project
  end

  def create
    @project = Project.new(project_params)
    @project.creator = current_user
    if params[:project][:users].any?
      params[:project][:users].reject!(&:empty?)
      @project.assigned_user = User.find( params[:project][:users])
    end
    authorize @project
    # respond_to do |format|
      if @project.save
        redirect_to @project
      else
        render :new, status: :unprocessable_entity
      end
    # end
  end

  def update
    @project = Project.find(params[:id])
    authorize @project
      if @project.update(project_params)
        redirect_to @project
      else
        render :edit
      end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    respond_to do |format|
      format.html {redirect_to projects_url, notice: 'Project was successfully destroyed.'}
      format.json {head :no_content}
    end
  end


  private

  def project_params
    params.require(:project).permit(:title, :description)
  end
end
