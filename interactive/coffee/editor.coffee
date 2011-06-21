window.editor = ace.edit("editor")

refocus()

run = ->

editor.coffee = ->
  CoffeeMode = require("ace/mode/coffee").Mode
  editor.getSession().setMode(new CoffeeMode())
  run = (code) ->
    eval CoffeeScript.compile code

editor.js = ->
  JsMode = require("ace/mode/javascript").Mode
  editor.getSession().setMode(new JsMode())
  run = (code) ->
    resetStyle code

editor.style = ->
  StyleMode = require("ace/mode/css").Mode
  editor.getSession().setMode(new StyleMode())
  run = (code) ->
    resetStyle code

$ ->
  $('#run').click ->
    do clear
    code = editor.getSession().getValue()
    run code
