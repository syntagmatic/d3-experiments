# load example
window.get = (settings) ->
  switch settings.type
    when 'coffee'
      $.ajax
        url: settings.file
        async: false
        success: (data) ->
          require settings.requirements, ->
            settings.coffee = data
            settings.js = CoffeeScript.compile data
            settings.help = settings.help
            print settings.intro
      return "Loading " + settings.name + "..."

# commands
window.help = (f) ->
  # TODO: formatting
  f.help
window.coffee = window.vim = (f) ->
  # TODO: open coffeescript editor
  # f.coffee
  if !coffee.editor
    run editcoffee
  coffee.editor.coffee()
  coffee.editor.getSession().setValue f.coffee
window.css = ->
  if !css.editor
    run editcoffee
  css.editor.style()
  css.editor.getSession().setValue $('#css').html()
window.js = (f) ->
  # TODO: open javascript editor
  f.js
window.run = (f) ->
  # TODO: arguments
  eval f.js
window.clear  = ->
  $('#canvas').html ''
  print 'Canvas cleared'

get editcoffee
