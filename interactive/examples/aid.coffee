require ["../d3/d3.geo.js"], ->
  xy = d3.geo.mercator().scale(1200)
  chart = d3.select("body")
    .append("svg:svg")
  path = d3.geo.path().projection(xy)
  
  d3.json "data/worldmap.json", (collection) ->
    chart.selectAll("path")
      .data(collection.features)
      .enter().append("svg:path")
      .attr("d", path)
      .append("svg:title")
      .text((d) -> d.properties.name)

style '
svg {
  width: 1060px;
  height: 600px;
}

path {
  stroke: #fff;
  stroke-width: .25px;
}
'
