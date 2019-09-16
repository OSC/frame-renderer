module ProjectsHelper
  def status_label(status, id, tag = :span)
    label_class = label_class_lookup(status)
    id = 'job-status-span-' + id.to_s

    content_tag tag, class: %I[status-label label #{label_class}], id: id do
      status
    end
  end

  def thumbnails(project_dir)
    Dir.glob(project_dir + '/thumbnails/*.png').sort
  end

  def thumbnail_to_exr(project_dir, thumbnail)
    basename = File.basename(thumbnail, '.png')
    project_dir + '/images/' + basename + '.exr'
  end

  private

  def label_class_lookup(status = Job.never_submitted_status)
    return 'label-info' if status == 'queued'
    return 'label-warning' if status == 'queued_held'
    return 'label-primary' if status == 'running'
    return 'label-success' if status == 'completed'
    return 'label-warning' if status == 'suspended'

    'label-default' # handles 'not submitted' and 'undetermined'
  end
end
