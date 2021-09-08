# frozen_string_literal: true

# ProjectFactory creates subclasses of Project
class ProjectFactory
  def self.new_project(params)
    case params[:project_type].to_s.downcase
    when 'maya'
      MayaProject.new(params.except(:project_type))
    when 'vray'
      VRayProject.new(params.except(:project_type))
    else
      MayaProject.new(params.except(:project_type))
    end
  end

  def self.maya_project?(project)
    project.is_a?(MayaProject)
  end
end
