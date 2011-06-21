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

# commands
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
