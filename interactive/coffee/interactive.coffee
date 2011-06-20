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

# style editor
$ ->
  $('#style').html $('#css').html()  # populate style editor with existing styles
  $('#style').keyup ->               # update styles on key up
    resetStyle $(this).val()
