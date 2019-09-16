module ScriptsHelper
  def normalize_css_str(str)
    str.to_s.sub(' ', '-')
  end
end
