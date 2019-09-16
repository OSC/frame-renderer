# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


@pollSubmissions = (project_id) ->
  update(project_id)
  setTimeout(pollSubmissions, 30000, project_id)

update = (project_id) ->
  $.ajax
    type: 'GET'
    url: Routes.project_scripts_path project_id, format: 'json'
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
# script_id: 1
# updated_at: "2019-08-16T17:13:02.052Z"

updateSubStatus = (data) ->
  data.forEach (job, index) ->
    statusSpanId = 'job-status-span-' + job.script_id
    jobIdCol = 'script-' + job.script_id + '-job-id'

    statusSpan = $('#' + statusSpanId)
    jobIdElement = $('#' + jobIdCol)

    newCssClass = 'status-label label label-' + statusToLabelLookup(job.status)
    statusSpan.attr('class', newCssClass)
    statusSpan.text(job.status)

    jobIdLink = $('<a>').attr('href', filesAppURL(job.directory)).text(job.job_id)
    jobIdElement.replaceWith(jobIdLink)
    toggleRunStop(job.status, job.script_id)

statusToLabelLookup = (status) ->
  if status == 'completed'
    return 'success'
  else if status == 'queued'
    return 'info'
  else if status == 'queued_held'
    return 'warning'
  else if status == 'running'
    return 'primary'
  else if status == 'suspended'
    return 'warning'
  if status == 'undetermined'
    return 'default'
  else
    # catches 'not submitted' state
    return 'default'

toggleRunStop = (status, script_id) -> 
  submitButtonId = 'submit-button-' + script_id
  stopButtonId = 'stop-button-' + script_id

  submitButton = $('#' + submitButtonId)
  stopButton = $('#' + stopButtonId)

  if status == 'queued' || status == 'running'
    submitButton.attr("disabled", true)
    submitButton.addClass("disabled")
    stopButton.attr("disabled", false)
    stopButton.removeClass("disabled")
  else
    submitButton.attr("disabled", false)
    submitButton.removeClass("disabled")
    stopButton.attr("disabled", true)
    stopButton.addClass("disabled")

filesAppURL = (job_dir) ->
  return '/pun/sys/files/fs' + job_dir