chart = d3.select("body")
  .append("div")
  .attr("class", "chart")
 
d3.json "data/us-economic-assistance.json", (collection) ->
  newCollection = getNewAid(collection.rows)
  ###
  chart.selectAll("div")
      .data(collection.features)
      .enter().append("div")
      .style("width", (d) -> d * 10 + "px")
      .text((d) -> d.properties.name)
  ###

getNewAid = (d) ->
  newAid = {}
  makeDate = (dt) ->
    dt = "" + dt
    y = dt.substring(2, 6)
    return parseInt(y)

  for row in d
    for key, val of row
      newAid[row.program_name] or= {}
      newAid[row.program_name][row.country_name] or= {}
      if key.substring(0,2) is "FY"
        date = makeDate(key)
        newAid[row.program_name][row.country_name][date] = val
  
  return newAid

style
  '.chart div':
    'font': '10px sans-serif'
    'background-color': 'steelblue'
    'text-align': 'right'
    'padding': '3px'
    'margin': '1px'
    'color': 'white'
