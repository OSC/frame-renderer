# frozen_string_literal: true

# Project class is meant to be subclassed for specific functionality
class Project < ApplicationRecord
  validates :name, presence: true, length: { minimum: 5 }, uniqueness: true
  validates :directory, presence: true
  validate :directory_must_be_valid
  validates_uniqueness_of :name
  has_many :scripts

  # add accessors: [ :attr1, :attr2 ] etc. when you want to add getters and
  # setters to add new attributes stored in the JSON store
  # don't remove attributes from this list going forward! only deprecate
  store :project_attrs, coder: JSON, accessors: %i[]

  # we use `project_type` to allow for the form to set this attr and use _it_
  # to determine the `type` which will instantiate subclasses.
  attr_accessor :project_type

  self.inheritance_column = :type

  def directory_must_be_valid
    errors.add(:directory, 'the directory must be valid') unless Dir.exist? directory
  end

  # subclasses should override this. It's kind of an awkward place to put this
  # knowledge of where the default Script.extra should be, but a script is tied
  # to a project so, it's the best place for now.
  def default_script_extra
    ''
  end
end
