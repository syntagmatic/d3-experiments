### Commands ###

state =
  activeModule: null
  staleCoffee: false
  mode: null
  run: ->

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
  state.activeModule = module
  if !module.coffee
    get module, (module) ->
      coffee module
    return
  editor.coffee()
  editor.getSession().setValue module.coffee
  setTimeout (-> editor.gotoLine(0)), 20

window.css = ->
  # open css editor
  editor.style()
  editor.getSession().setValue $('#css').html()

window.js = (module) ->
  state.activeModule = module
  # open javascript editor
  if !module.js
    get module, (module) ->
      js module
    return
  editor.js()
  editor.getSession().setValue module.js
  setTimeout (-> editor.gotoLine(0)), 20

window.run = (module) ->
  # TODO: arguments
  state.activeModule = module
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

editor.coffee = ->
  state.mode = 'coffee'
  CoffeeMode = require("ace/mode/coffee").Mode
  editor.getSession().setMode(new CoffeeMode())
  state.run = (code) ->
    state.activeModule.coffee = code
    compiled = CoffeeScript.compile code
    state.activeModule.js = compiled
    state.staleCoffee = false
    eval compiled

editor.js = ->
  state.mode = 'js'
  JsMode = require("ace/mode/javascript").Mode
  editor.getSession().setMode(new JsMode())
  state.run = (code) ->
    state.activeModule.js = code
    state.staleCoffee = true
    eval code

editor.style = ->
  state.mode = 'style'
  StyleMode = require("ace/mode/css").Mode
  editor.getSession().setMode(new StyleMode())
  state.run = (code) ->
    resetStyle code

editor.getSession().on 'change', ->
  if state.mode is 'style'
    resetStyle editor.getSession().getValue()

$ ->
  $('#hide').toggle ->
    $('#editor').fadeOut()
    $(this).html 'show'
  , ->
    $('#editor').fadeIn()
    $(this).html 'hide'
  $('#js').click ->
    js state.activeModule
  $('#coffee').click ->
    coffee state.activeModule
  $('#run').click ->
    do clear
    code = editor.getSession().getValue()
    state.run code
  $('#clear').click ->
    do clear
  $('#style').click ->
    do css
  $('#input').focus ->
    $('#output').show()
  $('#input').blur ->
    setTimeout ->
      if not $('#input').is(":focus")
        $('#output').fadeOut()
    , 30
