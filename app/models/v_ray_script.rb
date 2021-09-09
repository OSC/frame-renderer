# frozen_string_literal: true

# Script subclass for Maya rendering
class VRayScript < Script
  def self.model_name
    Script.model_name
  end

  def cores
    40
  end

  def cluster
    'pitzer'
  end

  def script_template
    'jobs/video_jobs/vray_submit.sh.erb'
  end

  def renderers
    # let's just the default right now
    ['0'].freeze
  end

  def job_name
    'vray-render'
  end

  def normalized_name
    name.parameterize(separator: '_')
  end
end
