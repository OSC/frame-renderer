class Job < ActiveRecord::Base
  include OscMacheteRails::Statusable
  
  belongs_to :submission
end
