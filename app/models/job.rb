require 'pathname'

class Job < ApplicationRecord
  belongs_to :script

  # add accessors: [ :attr1, :attr2 ] etc. when you want to add getters and
  # setters to add new attributes stored in the JSON store
  # don't remove attributes from this list going forward! only deprecate
  store :job_attrs, coder: JSON, accessors: %i[]

  class << self
    def default_scope
      # show latest job submission at the top
      order("#{table_name}.id DESC")
    end
  end

  def submit(content = nil, opts = {})
    options = opts.merge(content: content)
    script = OodCore::Job::Script.new(options)

    job_id = adapter.submit script # throw exception up the stack

    info = adapter.info(job_id)
    update(job_id: job_id, status: info.status.to_s)

    job_id # either throw an exception or you succeeded in submitting
  end

  def stop
    adapter.delete(job_id)
    update(status: adapter.status(job_id).to_s)
  end

  def update_status
    return if unable_to_update?

    info = adapter.info(job_id)
    update(status: info.status.to_s)
  end

  private

  def unable_to_update?
    status == 'completed'
  end

  def adapter
    cls = OodAppkit.clusters[cluster]
    raise "'#{cluster}' is not a correctly configured cluster" if cls.nil?
    cls.job_adapter
  end

end
