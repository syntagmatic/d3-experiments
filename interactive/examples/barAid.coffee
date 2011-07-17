chart = d3.select("#canvas")
minTime = 1946
maxTime = 2009
t = minTime
$('#canvas').append("<h2>" + t + "</h2><h1>US Foreign Economic Aid</h1><div class='clearfix'></div>")

countryList = []
for masterCountry, num of countryTotals
  countryList.push
    country: masterCountry

makeData = (countries) ->
  for country, dates of countries
    for i in countryList
      if country is i.country
        i.cash = dates[t]
  return countryList

d3.json "data/aid.json", (depts) ->
  for dept, countries of depts
    bar = chart.data(makeData(countries)).append("div").attr("class","bar")
    bar.append("label").text(dept)
    barInner = bar.append("div").attr("class","barInner")
    bar.append("p")
    bar.append("div").attr("class","clearfix")
    fillBar(countries, bar, barInner)
    updateBars countries, bar, barInner

$("h2").bind "click", ->
  if t < maxTime
    t += 1
  $('body').trigger('updateBars')

updateBars = (countries, bar, barInner) ->
  $('body').bind 'updateBars', ->
    barInner.selectAll("div").remove()
    fillBar(countries, bar, barInner)

fillBar = (countries, bar, barInner) ->
  barVal = 0
  $("h2").text(t)
  for country, dates of countries
    val = dates[t]
    barVal += val
    section = barInner.append("div")
                      .attr("class","section")
    makeSection(val, section, country)
  bar.selectAll("p").text("$"+barVal)

makeSection = (val, section, country) ->
    if val is null
      section.style("display", "none")
    else
      if val*.00000095 < 1
        newVal = 1
      else
        newVal = val*.00000095
      section.style("width", newVal + "px")
             .style("display","block")
             .attr("title", country + ": $" + val)
  
style
  '#canvas div':
    'font': '10px sans-serif'
  '#canvas .section':
    'float':'left'
    'border':'1px solid #ccc'
    'border-left':'0'
    'height':'20px'
  '#canvas .bar':
    'margin-bottom':'5px'
    'background':'#eee'
    'height':'20px'
  '.bar label':
    'float':'left'
    'padding':'0px 10px 0 0'
    'border-right':'1px solid #ccc'
    'text-align':'right'
    'width':'150px'
    'color':'#999'
    'height':'22px'
  '.bar .barInner':
    'float':'left'
  '.bar p':
    'float':'left'
    'padding-left':'5px'
    'line-height':'22px'
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
