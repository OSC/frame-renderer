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
    [
      ['V-Ray Renderer (0)', '0'],
      ['CPU RT engine (1)', '1'],
      ['GPU RT engine (5)', '5']
    ]
  end

  def job_name
    'vray-render'
  end

  def available_versions
    ['5.10.02']
  end

  def normalized_name
    name.parameterize(separator: '_')
  end
end
