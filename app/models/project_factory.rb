class ProjectFactory

  def self.new_project(params)
    MayaProject.new(params.except(:project_type)) #if maya_project?(params['type'])
  end

  def self.maya_project?(type)
    type.to_s == 'maya'
  end
end