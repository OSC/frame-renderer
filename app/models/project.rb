class Project < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true, length: { minimum: 5 }
  has_many :scripts

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

end
