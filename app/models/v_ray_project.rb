# frozen_string_literal: true

# Project subclass for Vray Projects
class VRayProject < Project
  def self.model_name
    Project.model_name
  end

  def scenes
    Dir.glob("#{directory}/scenes/**/**.vrscene")
  end

  def script_type
    'VRayScript'
  end
end
