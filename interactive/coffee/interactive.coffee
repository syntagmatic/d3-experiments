### Commands ###

# load example
window.get = (module, callback) ->
  switch module.type
    when 'coffee'
      $.ajax
        url: module.file
        async: false
        success: (data) ->
          require module.requirements, ->
            module.coffee = data
            module.js = CoffeeScript.compile data
            if callback
              callback module
            print module.intro
      return "Loading " + module.name + "..."

window.help = (module) ->
  # TODO: formatting
  module.help

window.coffee = window.vim = (module) ->
  # open coffeescript editor
  if !module.coffee
    get module, (module) ->
      editor.coffee()
      editor.getSession().setValue module.coffee
    return
  editor.coffee()
  editor.getSession().setValue module.coffee

window.css = ->
  # open css editor
  editor.style()
  editor.getSession().setValue $('#css').html()

window.js = (module) ->
  # open javascript editor
  if !module.js
    get module, (module) ->
      editor.js()
      editor.getSession().setValue module.js
    return
  editor.js()
  editor.getSession().setValue module.js

window.run = (module) ->
  # TODO: arguments
  eval module.js

window.clear  = ->
  $('#canvas').html ''
  print 'Canvas cleared'

### Styles ###
window.style = (style) ->
  for selector, rules of style
    addStyle '\r' + selector + ' {\r'
    for prop, value of rules
      addStyle '  ' + prop + ': ' + value + ';\r'
    addStyle '}\r'

window.addStyle = (string) ->
    $('#css').append string

window.resetStyle = (style) -> $('#css').html style

window.background = (color) -> $('body').css {background: color}

# style editor
# $ ->
#   $('#style').html $('#css').html()  # populate style editor with existing styles
#   $('#style').keyup ->               # update styles on key up
#     resetStyle $(this).val()


### Editor ###

window.editor = ace.edit("editor")

refocus()

# stub run
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
    eval code

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
  $('#clear').click ->
    do clear
  $('#style').click ->
    do css
