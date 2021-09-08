# frozen_string_literal: true

# ProjectFactory creates subclasses of Project
class ProjectFactory
  def self.new_project(params)
    MayaProject.new(params.except(:project_type))
  end

  def self.maya_project?(project)
    project.is_a?(MayaProject)
  end
end
