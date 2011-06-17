# styles
window.style = (style) ->
  for selector, rules of style
    addStyle '\r' + selector + ' {\r'
    for prop, value of rules
      addStyle '  ' + prop + ': ' + value + ';\r'
    addStyle '}\r'
window.addStyle = (string) ->
    $('#css').append string
    $('#style').append string
window.resetStyle = (style) -> $('#css').html style
window.background = (color) -> $('body').css {background: color}

# examples
window.example = (name) ->
  $.get 'examples/' + name + '.coffee', (data) ->
    eval CoffeeScript.compile(data)
  return

window.examples = ['force', 'stream', 'chord', 'splom', 'bar', 'aid', 'unemployment']
window.explanations =
  'force': "Click and drag nodes"
  'chord': "Hover over arcs to see connections"
  'splom': "Click and drag to select points"
  'stream': "Click update to toggle dataset"
  'unemployment': "Unemployment in the United States"
  'bar': "A basic bar chart"
  'aid': "US Foreign Aid"

for ex, i in examples
  $('#examples').append 'do ' + ex + '<br/>'
  do (ex) ->
    window[ex] = ->
      example ex
      print explanations[ex]

# d3
window.clear = ->
  d3.select('body').selectAll('svg').remove()
  print 'Canvas cleared'


$ ->
  $('#style').html $('#css').html()                 # populate style editor with existing styles
  $('#style').blur ->
    console.log $(this).val()
    resetStyle $(this).val()
