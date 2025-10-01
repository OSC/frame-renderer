# frozen_string_literal: true

# Script subclass for Maya rendering
class MayaScript < Script
  def self.model_name
    Script.model_name
  end

  def script_template
    Configuration.maya_script_template
  end

  def renderers
    [
      'arnold', 'default', 'file', 'hw2', 'hw',
      'interBatch', 'sw', 'turtle', 'turtlebake', 'vr'
    ].freeze
  end

  def cores
    Configuration.cores
  end

  def cluster
    Configuration.submit_cluster
  end

  def available_versions
    if accad?
      ['2023', '2025', '2026']
    else
      ['2025']
    end
  end

  def job_name
    'maya-render'
  end

  def accad?
    CurrentUser.group_names.include?('mayaosu')
  end
end
