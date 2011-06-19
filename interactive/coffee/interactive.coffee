# styles
window.style = (style) ->
  for selector, rules of style
    addStyle '\r' + selector + ' {\r'
    for prop, value of rules
      addStyle '  ' + prop + ': ' + value + ';\r'
    addStyle '}\r'
window.addStyle = (string) ->
    $('#css').append string
    $('#style').val $('#style').val() + string
window.resetStyle = (style) -> $('#css').html style
window.background = (color) -> $('body').css {background: color}

# examples
window.examples =
  'force':
    intro: "A force-directed layout. Click and drag nodes"
    file: "examples/force.coffee"
    requirements: ["../d3/d3.layout.js", "../d3/d3.geom.js"]
    help: "Usage: force [json file]"
  'chord':
    intro: "A network visualization. Hover over arcs to see connections"
    file: "examples/chord.coffee"
    requirements: ["../d3/d3.layout.js"]
  'splom':
    intro: "Mutliple scatterplots. Click and drag to select points"
    file: "examples/splom.coffee"
    requirements: []
  'stream':
    intro: "A streamgraph. Click update to toggle dataset"
    file: "examples/stream.coffee"
    requirements: ["../d3/d3.layout.js"]
  'unemployment':
    intro: "Unemployment in the United States"
    file: "examples/unemployment.coffee"
    requirements: ["../d3/d3.geo.js"]
  'bar':
    intro: "A basic bar chart"
    file: "examples/bar.coffee"
    requirements: []
###
  'aid':
    intro: "US Foreign Aid"
    file: "examples/aid.coffee"
    requirements: ["../d3/d3.geo.js"]
  'brain':
    intro: "Neural network with Brain.js"
    file: "examples/brain.coffee"
    requirements: ["js/brain.js"]
###

# load example
window.example = (name) ->
  settings = examples[name]
  $.get settings.file, (data) ->
    require settings.requirements, ->
      eval CoffeeScript.compile(data)
      print settings.intro
      window[name].help = -> print settings.help
  return

# run example by loading
for ex of examples
  $('#examples').append 'do ' + ex + '<br/>'
  do (ex) ->
    window[ex] = ->
      example ex

# help
window.help = (f) ->
  f.help()

# d3
window.clear = ->
  d3.select('body').selectAll('svg').remove()
  print 'Canvas cleared'


# style editor
$ ->
  $('#style').html $('#css').html()  # populate style editor with existing styles
  $('#style').keyup ->               # update styles on key up
    resetStyle $(this).val()
