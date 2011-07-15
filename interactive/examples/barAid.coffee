chart = d3.select("#canvas")
minTime = 1946
maxTime = 2009
t = minTime
$('#canvas').append("<h2>" + t + "</h2><h1>US Foreign Economic Aid</h1><div class='clearfix'></div>")

initAid = ->
  d3.json "data/aid.json", (depts) ->
    for dept, countries of depts
      bar = chart.append("div").attr("class","bar")
      bar.append("label").text(dept)
      fillBar(countries, bar)

$("h2").bind "click", ->
  t += 1

fillBar = (countries, bar) ->
  barVal = 0
  for country, dates of countries
    $("h2").text(t)
    val = dates[t]
    barVal += val
    makeSection(val, bar)
  bar.append("p").text(barVal)
  bar.append("div").attr("class","clearfix")

makeSection = (val, bar) ->
  if val isnt null
    if val*.0000008 < 1
      newVal = 1
    else
      newVal = val*.0000008
    bar.append("div")
       .attr("class","section")
       .style("width", newVal + "px")
  
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
    'height':'30px'
  '.bar label':
    'float':'left'
    'padding':'0px 10px 0 0'
    'border-right':'1px solid #ccc'
    'text-align':'right'
    'width':'150px'
    'color':'#999'
    'height':'32px'
  '.bar p':
    'float':'left'
    'padding-left':'5px'
    'line-height':'32px'
    'margin':'0'
  'h2':
    'font-family':'impact, ariel, helvetica, sans-serif'
    'font-size':'32px'
    'float':'left'
    'margin':'0'
    'color':'#ccc'
    'width':'150px'
    'text-align':'right'
    'padding-right':'10px'
  'h1':
    'float':'left'
    'text-transform':'uppercase'
    'line-height':'43px'
    'height':'36px'
    'margin':'0px'
  '.clearfix':
    'clear':'both'
 
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
