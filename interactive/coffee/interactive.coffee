do ->

  # math
  window.abs = Math.abs
  window.acos = Math.acos
  window.asin = Math.asin
  window.atan = Math.atan
  window.ceil = Math.ceil
  window.cos = Math.cos
  window.exp = Math.exp
  window.floor = Math.floor
  window.log = Math.log
  window.max = Math.max
  window.min = Math.min
  window.pi = Math.PI
  window.pow = Math.pow
  window.random = Math.random
  window.round = Math.round
  window.sin = Math.sin
  window.sqrt = Math.sqrt
  window.tan = Math.tan

  # styles
  window.background = (color) -> $('body').css {background: color}
  window.style = (style) -> $('#styles').append style

  # examples
  window.example = (name) ->
    $.get 'examples/' + name + '.coffee', (data) ->
      go data, 'coffee'

  # Resize Hacks
  # $(window).bind "resize", ->
  #   $('#canvas > svg').width($('#canvas').width()).height($('#canvas').height())
  # End hacks
