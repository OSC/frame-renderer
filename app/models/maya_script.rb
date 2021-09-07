# frozen_string_literal: true

# Script subclass for Maya rendering
class MayaScript < Script
  def self.model_name
    Script.model_name
  end

  def script_template
    Configuration.maya_script_template
  end
end
