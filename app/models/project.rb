class Project < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true, length: { minimum: 5 }
  has_many :submissions
end
