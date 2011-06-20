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
            print "Type 'run " + settings.name + "'"
      return "Loading " + settings.name + "..."

# run example by loading
for ex of examples
  $('#examples').append 'get ' + ex + '<br/>'

# help
window.help = (f) ->
  f.help

# coffeescript
window.coffee = (f) ->
  f.coffee

# coffeescript
window.js = (f) ->
  f.js

# run 
window.run= (f) ->
  eval f.js


# d3
window.clear = ->
  $('#canvas').html ''
  print 'Canvas cleared'
