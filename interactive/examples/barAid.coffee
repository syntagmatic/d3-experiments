chart = d3.select("body")
  .append("div")
  .attr("class", "chart")
 
  d3.json "data/us-economic-assistance.json", (collection) ->
  chart.selectAll("div")
      .data(collection.features)
      .enter().append("div")
      .style("width", (d) -> d * 10 + "px")
      .text((d) -> d.properties.name)

getNewAid = (d) ->
  newAid = {}
  makeDate = (dt) ->
    dt = "" + dt
    y = dt.substring(dt.length - 4)
    return parseInt(y)
    

style '
.chart div {
  font: 10px sans-serif;
  background-color: steelblue;
  text-align: right;
  padding: 3px;
  margin: 1px;
  color: white;
} 
'
