# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'click', '#qs-plantings-send', (e) ->
  planting_id = $('#qs-plantings-val').val()
  if planting_id != ''
    window.location.href = '/plantings/' + planting_id
