class Project < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true, length: { minimum: 5 }
  has_many :submissions

  class << self
    def maya_top_level_dir
      dir = Pathname.new(ENV['HOME']).join('maya', 'projects')
      dir.mkpath unless dir.exist?
      dir.to_s
    end
  end

  def initialize(params = {})
    super
    write_attribute(:directory, params[:directory] ||= Project.maya_top_level_dir)
  end

end
