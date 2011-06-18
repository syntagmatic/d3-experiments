xy = d3.geo.azimuthal().scale(240).mode("stereographic")
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

style
  svg:
    width: '960px'
    height: '500px'
  path:
    stroke: '#fff'
    'stroke-width': '.25px'
