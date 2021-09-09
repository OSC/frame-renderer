# frozen_string_literal: true

# Project subclass for Maya Projects
class MayaProject < Project
  def self.model_name
    Project.model_name
  end

  def scenes
    Dir.glob("#{directory}/scenes/**/**.m[ab]")
  end

  def script_type
    'MayaScript'
  end
end
