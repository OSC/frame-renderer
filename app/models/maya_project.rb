class MayaProject < Project

  def scenes
    Dir.glob("#{directory}/scenes/**/**.m[ab]")
  end
end
