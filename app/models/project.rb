class Project < ApplicationRecord
  validates :name, uniqueness: true, presence: true, length: { minimum: 5 }
  has_many :scripts

  # add accessors: [ :attr1, :attr2 ] etc. when you want to add getters and
  # setters to add new attributes stored in the JSON store
  # don't remove attributes from this list going forward! only deprecate
  store :project_attrs, coder: JSON, accessors: %i[]

  class << self
    def maya_top_level_dir
      dir = "#{Dir.home}/maya/projects/."
      FileUtils.mkdir_p dir unless Dir.exist? dir
      dir
    end
  end

  def initialize(params = {})
    super
    write_attribute(:directory, params.to_h[:directory] ||= Project.maya_top_level_dir)
  end

  def scenes
    Dir.glob(directory + '/scenes/**/**.m[ab]')
  end

end
