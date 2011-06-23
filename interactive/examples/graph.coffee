style
  node:
    fill: '#000'
  cursor:
    fill: 'none'
    stroke: 'brown'
    'pointer-events': 'none'
  link:
    stroke: '#999'

restart = ->
  force.start()
  vis.selectAll("line.link").data(links).enter().insert("svg:line", "circle.node")
     .attr (d) ->
       "class": "link"
       "x1": d.source.x
       "y1": d.source.y
       "x2": d.target.x
       "y2": d.target.y
  
  vis.selectAll("circle.node").data(nodes).enter().insert("svg:circle", "circle.cursor")
     .attr((d) ->
       "class": "node"
       "cx": d.x
       "cy": d.y
       "r": 4.5
     ).call force.drag

w = 960
h = 500
fill = d3.scale.category20()
nodes = []
links = []
vis = d3.select("#canvas").append("svg:svg").attr("width", w).attr("height", h)
force = d3.layout.force().distance(30).nodes(nodes).links(links).size([ w, h ])
cursor = vis.append("svg:circle").attr("r", 30).attr("transform", "translate(-100,-100)").attr("class", "cursor")
force.on "tick", ->
  vis.selectAll("line.link")
     .attr (d) ->
       "x1": d.source.x
       "y1": d.source.y
       "x2": d.target.x
       "y2": d.target.y
  
  vis.selectAll("circle.node")
     .attr (d) ->
       "cx": d.x
       "cy": d.y

vis.on "mousemove", ->
  cursor.attr "transform", "translate(" + d3.svg.mouse(this) + ")"

vis.on "mousedown", ->
  point = d3.svg.mouse(this)
  node =
    x: point[0]
    y: point[1]
  
  n = nodes.push(node)
  nodes.forEach (target) ->
    x = target.x - node.x
    y = target.y - node.y
    if Math.sqrt(x * x + y * y) < 30
      links.push
        source: node
        target: target
  
  restart()

restart()
