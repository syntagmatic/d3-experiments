editor = window.coffee.editor = window.css.editor = ace.edit("editor")

editor.coffee = ->
  CoffeeMode = require("ace/mode/coffee").Mode
  editor.getSession().setMode(new CoffeeMode())
editor.style = ->
  StyleMode = require("ace/mode/css").Mode
  editor.getSession().setMode(new StyleMode())
