# frozen_string_literal: true

module ScriptsHelper
  def normalize_css_str(str)
    str.to_s.sub(' ', '-')
  end

  def version_label(project)
    if ProjectFactory.maya_project?(project)
      'Maya'
    elsif ProjectFactory.vray_project?(project)
      'VRay'
    else
      'Maya'
    end
  end
end
