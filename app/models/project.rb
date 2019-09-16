class Project < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true, length: { minimum: 5 }
  has_many :scripts

  # add accessors: [ :attr1, :attr2 ] etc. when you want to add getters and
  # setters to add new attributes stored in the JSON store
  # don't remove attributes from this list going forward! only deprecate
  store :project_attrs, coder: JSON, accessors: %i[]

  class << self
    def maya_top_level_dir
      dir = "#{Dir.home}/maya/projects/."
      Dir.mkdir dir unless Dir.exist? dir
      dir
    end
  end

  def initialize(params = {})
    super
    write_attribute(:directory, params[:directory] ||= Project.maya_top_level_dir)
  end

  def list_scenes
    Dir.glob(directory + '/scenes/**/**.m[ab]')
  end

end
