class MayaProject < Project

  def self.model_name
    Project.model_name
  end

  def scenes
    Dir.glob("#{directory}/scenes/**/**.m[ab]")
  end
end
