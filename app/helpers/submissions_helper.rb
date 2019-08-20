module SubmissionsHelper
  def normalize_css_str(str)
    str.to_s.sub(' ', '-')
  end
end
