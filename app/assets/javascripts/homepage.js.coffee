# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'submit', '#qs-plantings-form', (e) ->
  e.preventDefault()

  planting_id = $('#qs-plantings-val').val()
  if planting_id == ''
    return false
  else
    window.location.href = '/plantings/' + planting_id
