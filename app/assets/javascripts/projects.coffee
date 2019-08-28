# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


@pollSubmissions = (project_id) ->
  update(project_id)
  setTimeout(pollSubmissions, 30000, project_id)

update = (project_id) ->
  $.ajax
    type: 'GET'
    url: Routes.project_submissions_path project_id, format: 'json'
    contentType: "application/json; charset=utf-8"
    dataType: "json"
    error: (jqXHR, textStatus, errorThrown) ->
      console.log jqXHR
    success: (data, textStatus, jqXHR) ->
      updateSubStatus(data)

# created_at: "2019-08-16T17:13:02.052Z"
# id: 5
# job_id: "Never-Submitted-fA_5HIA"
# status: "not submitted"
# submission_id: 1
# updated_at: "2019-08-16T17:13:02.052Z"

updateSubStatus = (data) ->
  data.forEach (job, index) ->
    statusSpanId = 'job-status-span-' + job.submission_id
    jobIdRow = 'submission-' + job.submission_id + '-job-id'

    statusSpan = $('#' + statusSpanId)
    jobIdElement = $('#' + statusSpan)

    newCssClass = 'status-label label label-' + statusToLabelLookup(job.status)
    statusSpan.attr('class', newCssClass)
    statusSpan.text(job.status)
    jobIdElement.text(job.job_id)

statusToLabelLookup = (status) ->
  if status == 'not submitted'
    return 'default'
  else if status == 'queued'
    return 'info'
  else if status == 'running'
    return 'success'
  else if status == 'completed'
    return 'primary'
  else
    return 'default'
