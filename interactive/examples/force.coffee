style
  'circle.node':
    'stroke': '#fff'
    'stroke-width': '1.5px'
  'line.link':
    'stroke': '#999'
    'stroke-opacity': .6

require ["../d3/d3.layout.js", "../d3/d3.geom.js"], ->
  w = 960
  h = 500
  fill = d3.scale.category20()

  vis = d3.select("body")
          .append("svg:svg")
          .attr(
            "width": w
            "height": h
          )
  
  d3.json "data/miserables.json", (json) ->
    force = d3.layout.force()
              .charge(-120)
              .distance(30)
              .nodes(json.nodes)
              .links(json.links)
              .size([w, h])
              .start()

    link = vis.selectAll("line.link")
              .data(json.links)
              .enter().append("svg:line")
              .style("stroke-width", (d) -> Math.sqrt(d.value) )
              .attr((d) -> 
                "class": "link"
                "x1": d.source.x
                "y1": d.source.y
                "x2": d.target.x
                "y2": d.target.y
              )

    node = vis.selectAll("circle.node")
              .data(json.nodes)
              .enter().append("svg:circle")
              .style("fill", (d) -> fill(d.group) )
              .call(force.drag)
              .attr((d) ->
                "class": "node"
                "cx": d.x
                "cy": d.y
                "r": 5
              )

    node.append("svg:title")
        .text( (d) -> d.name )

    vis.style("opacity", 1e-6)
       .transition()
       .duration(1000)
       .style("opacity", 1)

    force.on "tick", ->
      link.attr((d) ->
        "x1": d.source.x
        "y1": d.source.y
        "x2": d.target.x
        "y2": d.target.y
        )

      node.attr((d) ->
        "cx": d.x
        "cy": d.y
        )
