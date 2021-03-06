### Commands ###

state =
  activeModule: null
  staleCoffee: false
  mode: null
  run: ->

### Errors and Logging ###

window.log = print

# coffee compile

coffee_compile = (code) ->
  try
    coffee_code = CoffeeScript.compile code
    return coffee_code
  catch err
    println err, 'error'

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
            module.js = coffee_compile data
            if callback
              callback module
            print module.intro
      return "Loading " + module.name + "..."

window.help = (module) ->
  # TODO: formatting
  module.help

window.coffee = window.vim = (module, callback) ->
  # open coffeescript editor
  state.activeModule = module
  if !module.coffee
    get module, (module) ->
      coffee module, callback
    return
  editor.coffee()
  editor.getSession().setValue module.coffee
  setTimeout (-> editor.gotoLine(0)), 20
  if callback
    callback module

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
  if !module.coffee
    coffee module, (module) ->
      state.activeModule = module
      eval module.js
    return
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
  CoffeeMode = requireSafe("ace/mode/coffee").Mode
  editor.getSession().setMode(new CoffeeMode())
  state.run = (code) ->
    state.activeModule.coffee = code
    compiled = coffee_compile code
    state.activeModule.js = compiled
    state.staleCoffee = false
    eval compiled

editor.js = ->
  state.mode = 'js'
  JsMode = requireSafe("ace/mode/javascript").Mode
  editor.getSession().setMode(new JsMode())
  state.run = (code) ->
    state.activeModule.js = code
    state.staleCoffee = true
    eval code

editor.style = ->
  state.mode = 'style'
  StyleMode = requireSafe("ace/mode/css").Mode
  editor.getSession().setMode(new StyleMode())
  state.run = (code) ->
    resetStyle code

editor.getSession().on 'change', ->
  if state.mode is 'style'
    resetStyle editor.getSession().getValue()

$ ->
  $('#hide').toggle ->
    $('#widgets').css('bottom', '-200px')
    $(this).html 'show'
  , ->
    $('#widgets').css('bottom', '0px')
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

###
  $('#input').focus ->
    $('#output').show()
  $('#input').blur ->
    setTimeout ->
      if not $('#input').is(":focus")
        $('#output').fadeOut()
    , 30
###
