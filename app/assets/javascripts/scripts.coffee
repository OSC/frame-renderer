# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# toggle an element's visibility
@toggle = (elementId) ->
  jobInfo = $('#' + elementId)
  jobInfo.toggle()
  

@pollForUpdates = (project_id, submission_id) ->
  update(project_id, submission_id)
  setTimeout(pollForUpdates, 30000, project_id, submission_id)

update = (project_id, submission_id) ->
  $.ajax
    type: 'GET'
    url: Routes.project_script_jobs_path project_id, submission_id, format: 'json'
    contentType: "application/json; charset=utf-8"
    dataType: "json"
    error: (jqXHR, textStatus, errorThrown) ->
      console.log jqXHR
    success: (data, textStatus, jqXHR) ->
      updateElements(data)
    complete: ->
      #console.log 'complete'

# created_at: "2019-08-16T17:13:02.052Z"
# id: 5
# job_id: "Never-Submitted-fA_5HIA"
# status: "not submitted"
# submission_id: 1
# updated_at: "2019-08-16T17:13:02.052Z"

updateElements = (data) ->
  data.forEach (job, index) ->
    jobButtonId = 'job-' + job.id + '-button'
    jobButton = $('#' + jobButtonId)
    newCssClass = 'job-result-button job-result-button-' + normalizeCSS(job.status)
    jobButton.attr('class', newCssClass)
    jobButton.text(job.job_id + ' [' + job.status + ']')
 

normalizeCSS = (str) ->
  return str.replace(" ", "-");