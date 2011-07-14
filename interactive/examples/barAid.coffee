chart = d3.select("#canvas")
$('#canvas').append("h1").text("US Foreign Economic Aid")
 
d3.json "data/aid.json", (depts) ->
  for dept, countries of depts
    bar = chart.append("div").attr("class","bar")
    bar.append("label").text(dept)
    for country, dates of countries
      for key, val of dates
        if key is "1995" and val isnt null
          if val*.0000008 < 1
            val = 1
          else
            val = val*.0000008
          bar.append("div")
             .attr("class","section")
             .style("width", val + "px")
    bar.append("div").attr("class","clearfix")

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
        if key.substring(6,8).length isnt 2
          date = makeDate(key)
          newAid[row.program_name][row.country_name][date] = val

style
  '#canvas div':
    'font': '10px sans-serif'
  '#canvas .section':
    'float':'left'
    'border':'1px solid #ccc'
    'border-left':'0'
    'height':'30px'
  '#canvas .bar':
    'margin-bottom':'5px'
    'background':'#eee'
  '.bar label':
    'float':'left'
    'padding':'0px 10px 0 0'
    'border-right':'1px solid #ccc'
    'text-align':'right'
    'width':'150px'
    'color':'#999'
    'height':'32px'
  '.clearfix':
    'clear':'both'
