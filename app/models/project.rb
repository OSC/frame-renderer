class Project < ApplicationRecord
  validates :name, presence: true, length: { minimum: 5 }, uniqueness: true
  validates :directory, presence: true
  validate :directory_must_be_valid
  validates_uniqueness_of :name
  has_many :scripts
  self.inheritance_column = :type

  # add accessors: [ :attr1, :attr2 ] etc. when you want to add getters and
  # setters to add new attributes stored in the JSON store
  # don't remove attributes from this list going forward! only deprecate
  store :project_attrs, coder: JSON, accessors: %i[]

  def directory_must_be_valid
    unless Dir.exist? directory
      errors.add(:directory, "the directory must be valid")
    end
  end
end
