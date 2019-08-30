module ScriptsHelper

  def normalize_css_str(str)
    str.to_s.sub(' ', '-')
  end

  def list_scenes(project_dir)
    Dir.glob(project_dir + '/scenes/**/**.m[ab]')
  end

end
