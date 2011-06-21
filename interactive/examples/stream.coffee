$('#canvas').append '<button id="stream_update"">Update</button>'

stream_layers = (n, m, o) ->
  bump = (a) ->
    x = 1 / (.1 + Math.random())
    y = 2 * Math.random() - .5
    z = 10 / (.1 + Math.random())
    i = 0
    
    while i < m
      w = (i / m - y) * z
      a[i] += x * Math.exp(-w * w)
      i++
  o = 0  if arguments.length < 3
  d3.range(n).map ->
    a = []
    i = 0
    while i < m
      a[i] = o + o * Math.random()
      i++
    i = 0
    while i < 5
      bump a
      i++
    a.map stream_index
stream_waves = (n, m) ->
  d3.range(n).map (i) ->
    d3.range(m).map((j) ->
      x = 20 * j / m - i / 3
      2 * x * Math.exp(-.5 * x)
    ).map stream_index
stream_index = (d, i) ->
  x: i
  y: Math.max(0, d)


n = 20
m = 200
data0 = d3.layout.stack().offset("wiggle")(stream_layers(n, m))
data1 = d3.layout.stack().offset("wiggle")(stream_layers(n, m))
color = d3.scale.category20b()
w = $("#canvas").width()
h = 500
mx = m - 1
my = d3.max(data0.concat(data1), (d) ->
  d3.max d, (d) ->
    d.y0 + d.y
)
area = d3.svg.area().x((d) ->
  d.x * w / mx
).y0((d) ->
  h - d.y0 * h / my
).y1((d) ->
  h - (d.y + d.y0) * h / my
)
vis = d3.select("#canvas").append("svg:svg").attr("width", w).attr("height", h)
vis.selectAll("path").data(data0).enter().append("svg:path").style("fill", ->
  color Math.random()
).attr("class", "stream").attr "d", area
$("#stream_update").click ->
  d3.selectAll("path").data(->
    d = data1
    data1 = data0
    data0 = d
  ).transition().duration(2500).attr "d", area
