module ProjectsHelper

  def status_label(status, id, tag = :span)
    label_class = label_class_lookup(status)
    id = 'job-status-span-' + id.to_s

    content_tag tag, class: %I[status-label label #{label_class}], id: id do
      status
    end

  end

  private

  def label_class_lookup(status = Job.never_submitted_status)
    return 'label-default' if status == Submission.never_submitted_status
    return 'label-info' if status == 'queued'
    return 'label-success' if status == 'running'
    return 'label-success' if status == 'completed'
    'label-default'
  end

end