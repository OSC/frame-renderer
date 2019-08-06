class Submission < ActiveRecord::Base
  include OscMacheteRails::Statusable

  belongs_to :project
end
